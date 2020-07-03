import UIKit

// 使用信号量来控制并发线程的数量

let semaphore1 = DispatchSemaphore(value: 1)
for i in 0...10 {
    DispatchQueue.global().async {
        semaphore1.wait()
        print(i)
        semaphore1.signal()
    }
}

Thread.sleep(forTimeInterval: 1)
print("======")

let semaphore2 = DispatchSemaphore(value: 2)
for i in 0...10 {
    DispatchQueue.global().async {
        semaphore2.wait()
        print(i)
        semaphore2.signal()
    }
}
