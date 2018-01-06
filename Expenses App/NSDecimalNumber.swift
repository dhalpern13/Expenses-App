//
//  NSDecimalNumber.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-06.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//
// Code taken from: https://gist.github.com/mattt/1ed12090d7c89f36fd28

import Foundation

public func +(leftNumber: NSDecimalNumber, rightNumber: NSDecimalNumber) -> NSDecimalNumber {
    return leftNumber.adding(rightNumber)
}

public func -(leftNumber: NSDecimalNumber, rightNumber: NSDecimalNumber) -> NSDecimalNumber {
    return leftNumber.subtracting(rightNumber)
}

public func /(leftNumber: NSDecimalNumber, rightNumber: NSDecimalNumber) -> NSDecimalNumber {
    return leftNumber.dividing(by: rightNumber)
}
