import Foundation

/*
 队列：任务先进先出
 串行队列：任务先进先出，只有一个线程，当前执行完成再取出下一个任务执行
 并行队列：任务先进先出，可以开启多个线程，所以可以多个任务并行执行。但是任务过多时，GCD 会根据系统资源控制并行的数量，并不会让所有任务同时执行
 同步执行：提交任务到当前队列，任务执行完成才返回
 异步执行：提交任务到当前队列，并且立即返回
 */

/*
 为避免创建太多线程消耗系统资源，苹果推荐使用全局队列替换个人创建的并行队列
 对于串行队列，推荐将target参数设置为全局队列，可以在实现串行的同时最小化线程资源消耗
 */

// 这是一个串行队列
let serialQueue = DispatchQueue(label: "com.natai.serial", target: .global())


// MARK: - 线程开启
serialQueue.async { // 开新线程
    print(Thread.current)
}
serialQueue.sync {  // 当前线程
    print(Thread.current)
}
DispatchQueue.global().async {
    print(Thread.current)
    serialQueue.sync {  // 当前线程
        print(Thread.current)
    }
}


// MARK: - 同步异步
Thread.sleep(forTimeInterval: 0.5)
print("开始异步执行")
for i in 0...9 {
    serialQueue.async {
        print(i)
    }
}
print("主线程没有被阻塞，异步任务完成前就会被打印")

Thread.sleep(forTimeInterval: 1)

print("开始同步执行")
for i in 0...9 {
    serialQueue.sync {
        print(i)
    }
}
print("主线程被阻塞，同步任务完成后才会被打印")

print("全局队列同步执行")
DispatchQueue.global().sync {
    Thread.sleep(forTimeInterval: 0.5)
}
print("全局队列同步执行完成")


// MARK: - 线程死锁
// 死锁必然发生于串行队列；具体的，在串行队列中，给它自己同步添加任务，则死锁
Thread.sleep(forTimeInterval: 0.5)
//DispatchQueue.main.sync {
//    print("主队列同步执行")
//}

serialQueue.async {
    print("queue1开始同步执行")
    serialQueue.sync {
        print("queue1同步执行")
    }
    print("queue1同步执行完成")
}
