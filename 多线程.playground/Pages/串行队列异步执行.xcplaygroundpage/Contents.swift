import Foundation

let queue = DispatchQueue(label: "com.natai.test")
queue.async {
    print(Thread.current)
    print("串行队列异步执行")
}

DispatchQueue.main.async {
    print(Thread.current)
    print("主队列异步执行")
}
print("主队列执行完成")
