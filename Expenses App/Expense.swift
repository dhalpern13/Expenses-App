//
//  Expense.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-06.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Expense: Transaction {
    
    // Mark: Properties
    
    var payer: String
    
    init(date: Date, description: String, amount: NSDecimalNumber, payer: String) {
        super.init(date: date, description: description, amount: amount)
        
        self.payer = payer
    }
}
