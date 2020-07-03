import UIKit

let lock = NSLock()
var count = 10

func reduceCount() {
    while true {
        defer {
            lock.unlock()
        }
        lock.lock()
        if count > 0 {
            count = count - 1
            print(count)
            print(Thread.current)
        } else {
            return
        }
    }
}

DispatchQueue.global().async {
    reduceCount()
}
