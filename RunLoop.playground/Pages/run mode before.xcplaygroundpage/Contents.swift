import Foundation

class ThreadKeeper: NSObject {
    var thread: Thread?
    
    func startThread() {
        thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread?.start()
    }
    
    func manualAction() {
        print("manualAction start")
        guard let thread = thread else { return }
        // 触发source0
        perform(#selector(perforManualAction), on: thread, with: nil, waitUntilDone: false)
    }
    
    @objc private func keepThread() {
        print("keepThread")
        addObserver()
        perform(#selector(delayAction), with: nil, afterDelay: 1)
//        // 调用该方法可以手动退出runloop
//        perform(#selector(delayStop), with: nil, afterDelay: 2)
        RunLoop.current.add(NSMachPort(), forMode: .common)
        /*
         return after either the first input source is processed or limitDate is reached
         接收到第一个source或达到截止时间，退出runloop
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
    
    @objc private func delayStop() {
        print("delayStop")
        CFRunLoopStop(CFRunLoopGetCurrent())
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
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    keeper.manualAction()
}
