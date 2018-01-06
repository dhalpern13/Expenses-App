//
//  Transaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Transaction {
    
    // MARK: Properties
    
    var date: Date
    
    var description: String
    
    var amount: NSDecimalNumber
    
    init(date: Date, description: String, amount: NSDecimalNumber) {
        self.date = date
        self.description = description
        self.amount = amount
    }
}
