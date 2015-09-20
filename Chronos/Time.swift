//
//  Time.swift
//  Chronos
//
//  Created by Janosch Hildebrand on 14/02/15.
//  Copyright © 2015 Janosch Hildebrand. All rights reserved.
//

import Darwin

// TODO: Could add some more full featured timing functions
// Min time instead of mean, or other variants
// Return of measurement data / data structure so custom weighting can be applied...
// etc...

/// A simple stopwatch that counts the elapsed time since its creation.
public struct Stopwatch {
    /// The time the stopwatch was started.
    private let start: UInt64

    /// The timebase info used to interpret the results of mach_absolute_time.
    private static let timebase: mach_timebase_info_data_t = {
        var timebase = mach_timebase_info_data_t()
        mach_timebase_info(&timebase)
        return timebase
    }()

    /// Create a new stopwatch that counts the time elapsed since it was created.
    public init() {
        start = mach_absolute_time()
    }

    /// The number of nanoseconds that elapsed since this stopwatch was created.
    public func elapsed() -> Duration {
        let current = mach_absolute_time()
        let elapsed = current - start

        let timebase = Stopwatch.timebase
        let elapsedNano = (elapsed * numericCast(timebase.numer)) / numericCast(timebase.denom)

        return Duration(nanoseconds: Double(elapsedNano))
    }

    /// Time the time taken to execute `body` for `iterations` times.
    public static func time(iterations iterations: Int, @noescape body: () throws -> ()) rethrows -> Duration {
        precondition(iterations >= 0)

        // Warmup
        try body()

        let stopwatch = Stopwatch()
        for _ in 0..<iterations { try body() }
        return stopwatch.elapsed()
    }

    /// Time the execution of a single execution of `body`.
    public static func time(@noescape body: () throws -> ()) rethrows -> Duration {
        return try self.time(iterations: 1, body: body)
    }

    /// Returns the mean time for executing `body` after `iterations` iterations.
    public static func meanTime(iterations iterations: Int, @noescape body: () throws -> ()) rethrows -> Duration {
        let duration = try self.time(iterations: iterations, body: body)
        return duration / Double(iterations)
    }


/*
    public static func meanTime(iterations: Int, samples: Int, @noescape body: () throws -> ()) rethrows -> Duration {
        // TODO: could request real-time scheduling for thread
        // TODO: Could set thread affinity
        // thread_policy_set()

        // Warmup
        try body()

        // Get samples for the execution of two iterations
        let twoTimes = try (0..<samples).map {
            return try self.time(iterations: 2, body: body)
        }

        // Get samples for the execution of two+iterations iterations
        let twoPlusTimes = try (0..<samples).map {
            return try self.time(iterations: 2 + iterations, body: body)
        }

        // Calculate the min time
        let minTime = min(twoPlusTimes) - min(twoTimes)


        // Return the mean of the min time
        return Duration(nanoseconds: minTime / Double(iterations))
    }
*/

}
