import Foundation

class ThreadKeeper: NSObject {
    var port = NSMachPort()
    
    func startThread() {
        let thread = Thread(target: self, selector: #selector(keepThread), object: nil)
        thread.start()
    }
    

    @objc private func keepThread() {
        print("keepThread")
        perform(#selector(delayAction), with: nil, afterDelay: 1)
        RunLoop.current.add(port, forMode: .common)
        /*
         在until时间前该方法反复调用run(mode:before:)；
         手动移除所有source和timer并不能保证runloop退出，因为系统可能会自动添加source；
         */
        RunLoop.current.run(until: Date(timeInterval: 3, since: Date()))
        // 如果当前线程的runloop没有退出，则该代码不会执行
        print("runloop已退出")
    }
    
    @objc private func delayAction() {
//        // 在until时间钱移除source和timer，可能能退出当前ruloop
//        RunLoop.current.remove(port, forMode: .common)
        print("delayAction")
    }
}

let keeper = ThreadKeeper()
keeper.startThread()

