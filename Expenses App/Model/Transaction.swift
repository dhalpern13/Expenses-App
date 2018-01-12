//
//  Transaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Transaction:Comparable{
    
    
    var date: Date
    
    var description: String
    
    var amount: Decimal
    
    var category: String
    
    init(date: Date, description: String, amount: Decimal, category: String) {
        self.date = date
        self.description = description
        self.amount = amount
        self.category = category
    }
    
    static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func <(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date < rhs.date
    }
    
    
}
