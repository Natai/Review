import Foundation

class ThreadKeeper: NSObject {
    var port = NSMachPort()
    
    func startThread() {
        let thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread.start()

        // 延迟1s在thread上执行操作
        Thread.sleep(forTimeInterval: 1)
        perform(#selector(delayAction), on: thread, with: nil, waitUntilDone: false)
    }
    

    @objc private func keepThread() {
        print("keepThread")
        RunLoop.current.add(port, forMode: .common)
        /*
         该方法反复调用run(mode:before:)；
         手动移除所有source和timer并不能保证runloop退出，因为系统可能会自动添加source；
         如果想要退出runloop，不要使用该方法
         */
        RunLoop.current.run()
        // 如果当前线程的runloop没有退出，则该代码不会执行
        print("runloop已退出")
    }
    
    @objc private func delayAction() {
        print("delayAction")
    }
}

let keeper = ThreadKeeper()
keeper.startThread()
