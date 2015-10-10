//
//  Util.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 01/09/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//


@inline(never) public func consumeValue<T>(e: T) {
}


@transparent public func runTestcaseGroup<Input>(testcases testcases: [Input -> ()], names: [String], input: Input, iterations: Int) -> TestcaseGroupResult<Input> {
    precondition(testcases.count == names.count)
    precondition(iterations > 0)

    var results = [TestcaseResult]()
    for (name, testcase) in zip(names, testcases) {
        let times = Stopwatch.time(iterations: iterations) {
            testcase(input)
        }

        results.append(TestcaseResult(name: name, runtimes: times))
    }

    return TestcaseGroupResult(input: input, results: results)
}
