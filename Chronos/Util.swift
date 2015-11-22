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

