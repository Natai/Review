import Foundation

/*
 提供了线程阻塞与信号机制
 The lock protects your code while it tests the condition and performs the task triggered by the condition.
 The checkpoint behavior requires that the condition be true before the thread proceeds with its task.
 */

var count: Int = 0
let condition = NSCondition()

func consume() {
    condition.lock()
    while count == 0 {
        condition.unlock()
        condition.wait()
    }
    print("consume:\(count)")
    condition.unlock()
}

func product() {
    condition.lock()
    count += 1
    print("product:\(count)")
    condition.signal()
    condition.unlock()
}

Thread.detachNewThread {
    consume()
}
Thread.detachNewThread {
    product()
}
