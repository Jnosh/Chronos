//: Playground - noun: a place where people can play

import Chronos

let testcases = [mallocTest, ptrTest, appendTest, mapTest, rangeTest]
let names = ["C", "Ptr", "Append", "Map", "Range"]
let inputs = [10, 100, 1000, 1000, 10000, 100000, 1000000]
let iterations = 10



for input in inputs {
    let resultGroup = runTestcaseGroup(testcases: testcases, names: names, input: input, iterations: iterations)
    print(resultGroup)
}
