import Foundation

class ThreadKeeper: NSObject {
    var shouldKeepRunning = true
    
    func startThread() {
        let thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread.start()
        
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayAction), on: thread, with: nil, waitUntilDone: false)
        
        // 延迟1s在thread上停止runloop
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayStop), on: thread, with: nil, waitUntilDone: false)
        
        // 再延迟1s在thread上执行操作，perform后也会自动停止runloop
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayAction), on: thread, with: nil, waitUntilDone: false)
    }
    
    @objc private func keepThread() {
        // 子线程入口第一件事应该创建autoreleasepool
        autoreleasepool {
            print("keepThread")
            shouldKeepRunning = true
            addObserver()
            RunLoop.current.add(NSMachPort(), forMode: .common)
            // run(mode:before:)只能触发一次，所以要加while循环不断调用
            while shouldKeepRunning &&
                RunLoop.current.run(mode: .default, before: .distantFuture) {
                print("=====当次runloop已退出=====")
            }
            print("-----所有runloop已退出，不再重启-----")
        }
    }
    
    private func addObserver() {
        let observer = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, { (observer, activity, _) in
            switch activity {
            case .entry:
                print("即将进入runloop")
            case .beforeTimers:
                print("即将触发Timer回调")
            case .beforeSources:
                print("即将触发Source回调")
            case .beforeWaiting:
                print("即将进入休眠")
            case .afterWaiting:
                print("刚刚唤醒runloop")
            case .exit:
                print("即将退出runloop")
            default:
                break
            }
        }, nil)
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
    }
    
    // 如果该方法被调用，则表明delayStop()方法无效
    @objc private func delayAction() {
        print("delayAction")
    }
    
    // 调用该方法可以手动退出runloop
    @objc private func delayStop() {
        print("delayStop")
        // 退出while循环
        shouldKeepRunning = false
        // 不管是否收到source，强制退出当前runloop
        CFRunLoopStop(CFRunLoopGetCurrent())
    }
}

let keeper = ThreadKeeper()
keeper.startThread()
