//
//  TestcaseResult.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 31/08/15.
//
//

import Foundation

// Alternative: Build runner so test perform timing themselves
// -> Test returns Duration as result
// -> would have to do Stopwatch in each test but can more easily do preparation stuff


public struct TestcaseResult {
    let name: String
    let time: Duration
}

extension TestcaseResult : CustomStringConvertible {
    public var description: String {
        return "\(name): \(time)"
    }
}

public struct TestcaseGroupResult<Input> {
    let input: Input
    let results: [TestcaseResult]
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
        
        let fastest = results.reduce(DBL_MAX) { fastest, testcase in
            return min(fastest, testcase.time.nanoseconds)
        }
        let scale = Scale(value: fastest)
        
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