import Foundation

/*
 Thread的取消和Operation类似，只把isCancelled置为true，不会取消正在执行的操作，所以需要在代码逻辑里面判断
 */

let thread = Thread {
    for i in 0...9 {
        Thread.sleep(forTimeInterval: 0.5)
        if Thread.current.isCancelled { return }
        print(i)
    }
}
thread.start()

DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    thread.cancel()
}
