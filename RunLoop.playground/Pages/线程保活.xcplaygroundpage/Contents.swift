import Foundation

class ThreadKeeper: NSObject {
    var shouldKeepRunning = true
    var thread: Thread?
    
    func startThread() {
        thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread?.start()
    }
    
    func manualAction() {
        print("manualAction start")
        guard let thread = thread else { return }
        // 触发source0，然后runloop会退出
        perform(#selector(perforManualAction), on: thread, with: nil, waitUntilDone: false)
    }
    
    @objc private func keepThread() {
        // 子线程入口第一件事应该创建autoreleasepool
        autoreleasepool {
            print("keepThread")
            shouldKeepRunning = true
            addObserver()
            perform(#selector(delayAction), with: nil, afterDelay: 1)
            // 调用该方法可以手动退出runloop
            perform(#selector(delayStop), with: nil, afterDelay: 3)
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
    
    @objc private func delayStop() {
        print("delayStop")
        // 退出while循环
        shouldKeepRunning = false
        // 不管是否收到source，强制退出当前runloop
        CFRunLoopStop(CFRunLoopGetCurrent())
        print("1111")
    }
    
    @objc private func delayAction() {
        print("delayAction")
    }
    
    // 如果该方法被调用，则表明delayStop()方法无效
    @objc private func perforManualAction() {
        print("perforManualAction")
    }
}

let keeper = ThreadKeeper()
keeper.startThread()
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    // 手动触发source，退出当前runloop。但是因为while循环，所以会重新启动下一个runloop
    keeper.manualAction()
}
