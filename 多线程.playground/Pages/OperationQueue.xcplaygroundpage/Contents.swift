import Foundation

// MARK: - 取消
let cancelOperation = BlockOperation()
cancelOperation.addExecutionBlock { [unowned cancelOperation] in
    for i in 0...9 {
        Thread.sleep(forTimeInterval: 0.5)
        if cancelOperation.isCancelled { return }
        print("取消", i)
    }
}
let cancelQueue = OperationQueue()
cancelQueue.addOperation(cancelOperation)

DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    // queue的取消还是要靠operation自己判断isCancelled
    cancelQueue.cancelAllOperations()
}


// MARK: - 并发数
Thread.sleep(forTimeInterval: 1.5)
let serialQueue = OperationQueue()
serialQueue.maxConcurrentOperationCount = 1
for i in 0...9 {
    serialQueue.addOperation {
        print("并发数", i)
    }
}


// MARK: - Order
Thread.sleep(forTimeInterval: 0.5)
let orderQueue = OperationQueue()
let orderOperation1 = BlockOperation {
    print("orderOperation1")
}
let orderOperation2 = BlockOperation {
    print("orderOperation2")
}
let orderOperation3 = BlockOperation {
    print("orderOperation3")
}
// 添加依赖
orderOperation2.addDependency(orderOperation1)
orderOperation3.addDependency(orderOperation1)
orderQueue.addOperation(orderOperation2)
orderQueue.addOperation(orderOperation3)
Thread.sleep(forTimeInterval: 0.5)
orderQueue.addOperation(orderOperation1)
