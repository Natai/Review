import Foundation

// 可以被同一个线程多次获得而不会导致死锁
let lock = NSRecursiveLock()

lock.lock()
lock.lock()
print("test lock")
