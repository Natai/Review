import Foundation

/*
 相对GCD的优点：
 可取消
 可暂停
 可观察状态（KVO）
 依赖实现方便
 面向对象可继承，方便封装任务
 */

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


// MARK: - 暂停
Thread.sleep(forTimeInterval: 2)
let pauseQueue = OperationQueue()
pauseQueue.addOperation {
    for i in 0...9 {
        Thread.sleep(forTimeInterval: 0.5)
        print("暂停", i)
    }
}

DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    pauseQueue.addOperation {
        print("first operation")
    }
}

DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
    // 只可以暂停未开始的operation
    pauseQueue.isSuspended = true
}

DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    pauseQueue.addOperation {
        print("second operation")
    }
}

DispatchQueue.global().asyncAfter(deadline: .now() + 2.5) {
    // 重新启动operations
    pauseQueue.isSuspended = false
}


// MARK: - 并发数
Thread.sleep(forTimeInterval: 3)
let serialQueue = OperationQueue()
// 变成了串行队列
serialQueue.maxConcurrentOperationCount = 1
for i in 0...9 {
    serialQueue.addOperation {
        print("并发数", i)
    }
}


// MARK: - Order
// 不可以使用queuePriority来确定operation的执行顺序，必须添加依赖
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
