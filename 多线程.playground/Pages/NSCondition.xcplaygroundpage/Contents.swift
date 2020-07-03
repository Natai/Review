import Foundation

var test: Int?
let condition = NSCondition()

func consume() {
    condition.lock()
    while test == nil {
        print("wait")
        condition.unlock()
        condition.wait()
    }
    print("consume:\(test!)")
    test == nil
    print(test!)
    condition.unlock()
}

func product(value: Int) {
    condition.lock()
    test = value
    print("product:\(value)")
    condition.signal()
    condition.unlock()
}

Thread.detachNewThread {
    consume()
}
for i in 0...10 {
    DispatchQueue.global().async {
        product(value: i)
    }
    Thread.sleep(forTimeInterval: 1)
}
