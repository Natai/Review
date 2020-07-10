import Foundation

//let operation = BlockOperation {
//    print("block")
//    print(Thread.current)
//}
//operation.start()

DispatchQueue.global().async {
    print(Thread.current)
    let operation = BlockOperation {
        print("block")
        print(Thread.current)
        Thread.sleep(forTimeInterval: 0.5)
    }
    operation.start()
    print("start operation")
}
