//
//  Util.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 01/09/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//

/// Function that "consumes" any value and should not be optimized away.
///
/// Useful to force the compiler (aka Mr. Smartypants) into assuming potential side-effects
/// when realizes that we are not doing any "real" work.
@inline(never) public func consumeValue<T>(e: T) {
}


// TODO: Generalize
//  * Need a prepare & cleanup? phase for some tests.
//      * feed input into prepare phase; create actual input for run; default can be identity
//
//  * Should this be part of TestcaseGroup or separate? WHat kind of interface?
//      * Too many arguments/options for functions/methods
//      * Could use some instance that is configured
//      * Or build on TestcaseType. Probably cleanest but needs more boilerplate
//      * if we make each test a type :-(
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
