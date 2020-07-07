import Foundation

let lock = NSConditionLock.init(condition: 0)

DispatchQueue.global().async {
    if lock.tryLock(whenCondition: 0) {
        print("线程1执行")
        sleep(1)
        lock.unlock(withCondition: 1)
    } else {
        print("线程1加锁失败")
    }
}
DispatchQueue.global().async {
    // 满足条件时才能获取锁
    lock.lock(whenCondition: 3)
    print("线程2执行")
    sleep(1)
    // 解锁并设置condition值
    lock.unlock(withCondition: 2)
}
DispatchQueue.global().async {
    lock.lock(whenCondition: 1)
    print("线程3执行")
    sleep(1)
    lock.unlock(withCondition: 3)
}
