import Foundation

class ThreadKeeper: NSObject {
    func startThread() {
        let thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread.start()
        
        // 延迟1s在thread上停止runloop
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayStop), on: thread, with: nil, waitUntilDone: false)
        
        // 再延迟1s在thread上执行操作，perform后也会自动停止runloop
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayAction), on: thread, with: nil, waitUntilDone: false)
    }
    
    @objc private func keepThread() {
        print("keepThread")
        addObserver()
        RunLoop.current.add(NSMachPort(), forMode: .common)
        /*
         return after either the first input source is processed or limitDate is reached
         接收到第一个source或达到截止时间，退出runloop（perform也是一个source，timer不是）
         */
        RunLoop.current.run(mode: .default, before: .distantFuture)
        print("runloop已退出")
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
        CFRunLoopStop(CFRunLoopGetCurrent())
    }
}

let keeper = ThreadKeeper()
keeper.startThread()
