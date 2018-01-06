//
//  Payment.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-06.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Payment: Transaction {
    
    init(date: Date, amount: NSDecimalNumber) {
        super.init(date: date, description: "Payment", amount: amount)
    }
}
