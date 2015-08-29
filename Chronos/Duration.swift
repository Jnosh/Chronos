//
//  Duration.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 29/08/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//

/// Represents a time interval with nanosecond precision.
public struct Duration {
    /// The duration in nanoseconds
    public let nanoseconds: Double

    /// Initialize a new Duration
    ///
    /// Double gives us nanosecond precision for up to ~100 days
    public init(nanoseconds: Double) {
        self.nanoseconds = nanoseconds
    }

    /// The Duration in microseconds
    public var microseconds: Double {
        return nanoseconds / 1_000
    }

    /// The Duration in milliseconds
    public var milliseconds: Double {
        return nanoseconds / 1_000_000
    }

    /// The Duration in seconds - this is essentially a NSTimeInterval
    public var seconds: Double {
        return nanoseconds / 1_000_000_000
    }
}

extension Duration : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch abs(nanoseconds) {
        case 0..<1_000:
            return "\(nanoseconds)ns"
        case 1_000..<1_000_000:
            return "\(microseconds)µs"
        case 1_000_000..<1_000_000_000:
            return "\(milliseconds)ms"
        default:
            return "\(seconds)s"
        }
    }

    public var debugDescription: String {
        return self.description
    }
}


extension Duration: Equatable { }
public func ==(lhs: Duration, rhs: Duration) -> Bool {
    return lhs.nanoseconds == rhs.nanoseconds
}

extension Duration: Comparable { }
public func <(lhs: Duration, rhs: Duration) -> Bool {
    return lhs.nanoseconds < rhs.nanoseconds
}

extension Duration: Hashable {
    public var hashValue: Int {
        return nanoseconds.hashValue
    }
}

public func +(lhs: Duration, rhs: Duration) -> Duration {
    return Duration(nanoseconds: lhs.nanoseconds + rhs.nanoseconds)
}

public func -(lhs: Duration, rhs: Duration) -> Duration {
    return Duration(nanoseconds: lhs.nanoseconds - rhs.nanoseconds)
}

public func *(lhs: Duration, rhs: Double) -> Duration {
    return Duration(nanoseconds: lhs.nanoseconds * rhs)
}

public func *(lhs: Double, rhs: Duration) -> Duration {
    return Duration(nanoseconds: lhs * rhs.nanoseconds)
}

public func /(lhs: Duration, rhs: Double) -> Duration {
    return Duration(nanoseconds: lhs.nanoseconds / rhs)
}

