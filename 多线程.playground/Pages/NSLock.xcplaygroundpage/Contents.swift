import UIKit

let lock = NSLock()
var count = 0

func reduceCount() {
    lock.lock()
    count += 1
    print(count)
    lock.unlock()
}

for _ in 0...10 {
    DispatchQueue.global().async {
        reduceCount()
    }
}

Thread.sleep(forTimeInterval: 1)

DispatchQueue.global().async {
    lock.lock()
    print("线程1执行")
    sleep(3)
    print("线程1解锁")
    lock.unlock()
}
DispatchQueue.global().async {
    sleep(1)
    // try试图获取一个锁，但是如果锁不可用的时候，它不会阻塞线程
    print("线程2尝试获取锁")
    if lock.try() {
        print("线程2执行")
    } else{
        print("线程2加锁失败")
    }
}
DispatchQueue.global().async {
    sleep(1)
    // lock(before:)方法试图获取一个锁，它会让线程从阻塞状态变为非阻塞状态，直到获取到锁或者超时
    print("线程3开始阻塞")
    if lock.lock(before: Date(timeIntervalSinceNow: 1)) {
        print("线程3执行")
    }else{
        print("线程3加锁失败")
    }
}

let lock2 = NSLock()
// 同一线程两次调用lock()将锁死线程
lock2.lock()
lock2.lock()
print("test lock")
