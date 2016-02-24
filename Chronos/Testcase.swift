//
//  Testcase.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 22/04/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//

public protocol TestcaseType {
    associatedtype Input
    var name: String { get }
    func run(input: Input) -> Duration
}


public struct AnyTestcase<Input> : TestcaseType {
    public let name: String
    public let run: Input -> Duration

    public init(name: String, run: Input -> Duration) {
        self.name = name
        self.run = run
    }
    
    public init(name: String, run: Input -> ()) {
        self.name = name
        self.run = { input in
            Stopwatch.time {
                run(input)
            }
        }
    }

    public init<Testcase: TestcaseType where Testcase.Input == Input>(_ testcase: Testcase) {
        name = testcase.name
        run = testcase.run
    }
    
    public func run(input: Input) -> Duration {
        return run(input)
    }
}
