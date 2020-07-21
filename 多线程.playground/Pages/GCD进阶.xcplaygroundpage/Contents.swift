import Foundation

// MARK: - Barrier
/*
 将要执行到barrier方法的时候，会等待当前队列的所有任务完成，然后才能执行barrier任务
 async(flags: .barrier)方法必须在自定义的并行队列中调用。如果在main、global队列中使用，则等同于asyncAfter
 */
let barrierQueue = DispatchQueue(label: "com.natai.barrier", attributes: [.concurrent])
barrierQueue.async {
    print("before barrier 1")
}
barrierQueue.async {
    print("before barrier 2")
    Thread.sleep(forTimeInterval: 1)
}
// 1s后任务才被提交到队列中，所以barrier对该任务无效
barrierQueue.asyncAfter(deadline: .now() + 2.5) {
    print("asyncAfter")
}
barrierQueue.async(flags: .barrier) {
    print("doing barrier")
    Thread.sleep(forTimeInterval: 1)
}
barrierQueue.async {
    print("after barrier")
}


// MARK: - Group
Thread.sleep(forTimeInterval: 3)
let group = DispatchGroup()
group.enter()
DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    print("group waiting")
    group.leave()
}
print("group start wait")
group.wait()
group.enter()
DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    print("group leave1")
    group.leave()
}
group.enter()
DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    print("group leave2")
    group.leave()
}
group.notify(queue: .main) {
    print("notify")
}
