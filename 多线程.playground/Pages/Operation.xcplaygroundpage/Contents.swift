import Foundation

/*
 默认情况下，opeation都是同步执行
 如果想要一个异步的operation，需要自己实现operation的子类，至少需要重写以下方法和属性：
    start()、isAsynchronous、isExecuting、isFinished
    来实现手动管理operation状态，这些状态还必须是线程安全的
    并且isExecuting、isFinished还需要手动发送KVO通知
 异步operation的事例：https://github.com/AFNetworking/AFNetworking/blob/2.7.0/AFNetworking/AFURLConnectionOperation.m
 将operation加入queue后，系统已经自动实现了异步
 */

let operation = BlockOperation()
operation.addExecutionBlock { [unowned operation] in
    // 同步执行，所以下方的取消方法需要在start前注册，否则循环完后才开始取消
    print(Thread.current)
    for i in 0...9 {
        Thread.sleep(forTimeInterval: 0.5)
        if operation.isCancelled { return }
        print(i)
    }
}

DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    // operation未开始的可以直接取消，不进入执行；已开始的，需要手动判断isCancelled
    print("未取消", operation.isCancelled, operation.isFinished, operation.isReady)
    operation.cancel()
    print("刚取消", operation.isCancelled, operation.isFinished, operation.isReady)
}

operation.start()
print("已取消", operation.isCancelled, operation.isFinished, operation.isReady)
