//
//  TestcaseResult.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 31/08/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//

import Foundation

// Alternative: Build runner so test perform timing themselves
// -> Test returns Duration as result
// -> would have to do Stopwatch in each test but can more easily do preparation stuff


public struct TestcaseResult {
    public let name: String
    public let time: Duration
    
    public init(name: String, time: Duration) {
        self.name = name
        self.time = time
    }
}

extension TestcaseResult : CustomStringConvertible {
    public var description: String {
        return "\(name): \(time)"
    }
}

public struct TestcaseGroupResult<Input> {
    public let input: Input
    public let results: [TestcaseResult]
    
    public init(input: Input, results: [TestcaseResult]) {
        self.input = input
        self.results = results
    }
}

private enum Scale: String {
    case Nanoseconds = "ns"
    case Microseconds = "us"
    case Milliseconds = "ms"
    case Seconds = "s"
    
    var factor: Double {
        switch self {
        case Nanoseconds: return 1
        case Microseconds: return 1_000
        case Milliseconds: return 1_000_000
        case Seconds: return 1_000_000_000
        }
    }
    
    init(value: Double) {
        switch abs(value) {
        case 0..<1_000: self = .Nanoseconds
        case 1_000..<1_000_000: self = .Microseconds
        case 1_000_000..<1_000_000_000: self = .Milliseconds
        default: self = .Seconds
        }
    }
}

extension TestcaseGroupResult : CustomStringConvertible {
    public var description: String {
        let separator: Character = "="
        let space: Character = " "
        let newline = "\n"
        var result: String = ""
        
        let inputDescription = String(input)
        let inputLength = inputDescription.characters.count
        
        let nameLength = results.reduce(0) { length, testcase in
            let nameLength = testcase.name.characters.count
            return max(length, nameLength)
        }
        
        let lineLength = max(nameLength, inputLength) + 14
        
        
        let inputPadding = (lineLength - inputLength - 2) / 2
        let extraPadding = (lineLength - inputLength - 2) % 2
        result += String(count: inputPadding, repeatedValue: separator)
        result += " " + inputDescription + " "
        result += String(count: inputPadding + extraPadding, repeatedValue: separator)
        result += newline

        let sorted = results.sort { $0.time < $1.time }
        let median = sorted[sorted.count / 2]
        let scale = Scale(value: median.time.nanoseconds)
        
        for testcase in results {
            let name = testcase.name
            let time = NSString(format: "%#.4g", testcase.time.nanoseconds / scale.factor) as String
            let padding = lineLength - name.characters.count - time.characters.count - 3
            result += testcase.name
            result += ":" + String(count: abs(padding), repeatedValue: space)
            result += time + scale.rawValue
            result += newline
        }
        
        result += String(count: lineLength, repeatedValue: separator)
        result += newline
        return result
    }
}