import Foundation

public func mallocTest(n: Int) {
    let array = malloc(n * sizeof(Int))
    memset_s(array, n * sizeof(Int), 0, n * sizeof(Int))
    free(array)
}

public func ptrTest(n: Int) {
    let base = UnsafeMutablePointer<Int>.alloc(n)
    for i in 0..<n {
        base[i] = i
    }
    base.destroy(n)
    base.dealloc(n)
}

public func appendTest(n: Int) {
    var array = Array<Int>()
    array.reserveCapacity(n)
    for i in 0..<n {
        array.append(i)
    }
}

public func mapTest(n: Int) {
    let range = 0..<n
    let _ = range.map { $0 }
}

public func rangeTest(n: Int) {
    let _ = Array(0..<n)
}
