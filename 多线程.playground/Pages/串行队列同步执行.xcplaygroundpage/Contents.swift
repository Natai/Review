import Foundation

let queue = DispatchQueue(label: "com.natai.test")
queue.sync {
    print(Thread.current)
    print("串行队列同步执行")
}

DispatchQueue.main.sync {
    print(Thread.current)
    print("主队列同步执行")
}
print("主队列执行完成")
