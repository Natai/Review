import Foundation

class CustomThread: Thread {
    override func main() {
        print(111)
    }
}

CustomThread.detachNewThread {
    print(222)
}
