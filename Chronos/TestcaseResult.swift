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
    public let runtimes: [Duration]
    
    public init(name: String, time: Duration) {
        self.name = name
        self.runtimes = [time]
    }

    public init(name: String, runtimes: [Duration]) {
        precondition(runtimes.count > 0, "'runtimes' must contain at least one entry.")

        self.name = name
        self.runtimes = runtimes
    }

    public var min: Duration {
        return minElement(runtimes)
    }

    public var max: Duration {
        return maxElement(runtimes)
    }

    public var mean: Duration {
        let total = runtimes.reduce(0.0) { return $0 + $1.nanoseconds }
        return Duration(nanoseconds: total / Double(runtimes.count))
    }

    public var median: Duration {
        let sorted = runtimes.sorted(<)
        return sorted[sorted.count / 2]
    }

    public var stddev: Duration {
        let mean = self.mean

        let variance = runtimes.map { $0.nanoseconds - mean.nanoseconds }
                                .map { $0 * $0 }
                                .reduce(0, combine: +) / Double(runtimes.count)

        return Duration(nanoseconds: sqrt(variance))
    }
}

extension TestcaseResult : Printable {
    public var description: String {
        return "\(name): \(time)"
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


// TODO: Group names
// TODO: display options

public struct TestcaseGroupResult<Input> {
    public let input: Input
    public let results: [TestcaseResult]
    
    public init(input: Input, results: [TestcaseResult]) {
        self.input = input
        self.results = results
    }
}

extension TestcaseGroupResult : Printable {
    public var description: String {
        let separator: Character = "="
        let space: Character = " "
        let newline = "\n"
        var result: String = ""
        
        let inputDescription = "\(input)"
        let inputLength = countElements(inputDescription)

        let nameLength = results.reduce(0) { length, testcase in
            let nameLength = countElements(testcase.name)
            return max(length, nameLength)
        }


        let format = ": ##########tt    σ: ##########tt"
        let lineLength = max(nameLength, inputLength) + countElements(format)

        
        let inputPadding = (lineLength - inputLength - 2) / 2
        let extraPadding = (lineLength - inputLength - 2) % 2
        result += String(count: inputPadding, repeatedValue: separator)
        result += " " + inputDescription + " "
        result += String(count: inputPadding + extraPadding, repeatedValue: separator)
        result += newline

        let sorted = results.map { $0.mean }.sorted(<)
        let median = sorted[sorted.count / 2]
        let scale = Scale(value: median.nanoseconds)
        
        for testcase in results {
            let name = testcase.name
            let time = NSString(format: "%10.4g", testcase.mean.nanoseconds / scale.factor) as String
            let stddev = NSString(format: "%10.4g", testcase.stddev.nanoseconds / scale.factor) as String
            let resultString = time + scale.rawValue + "    σ: " + stddev + scale.rawValue
            let padding = lineLength - countElements(name) - countElements(resultString) - 1
            result += name + ":"
            result += String(count: abs(padding), repeatedValue: space)
            result += resultString
            result += newline
        }
        
        result += String(count: lineLength, repeatedValue: separator)
        result += newline
        return result
    }
}