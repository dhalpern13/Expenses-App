//
//  Transaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Transaction: NSObject, Comparable, NSCoding{
    
    
    var date: Date
    
    var descript: String
    
    var amount: Decimal
    
    var category: String
    
    init(date: Date, descript: String, amount: Decimal, category: String) {
        self.date = date
        self.descript = descript
        self.amount = amount
        self.category = category
    }
    
    static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func <(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date < rhs.date
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.descript = aDecoder.decodeObject(forKey: "descript") as! String
        self.amount = aDecoder.decodeObject(forKey: "amount") as! Decimal
        self.category = aDecoder.decodeObject(forKey: "category") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.descript, forKey: "descript")
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.category, forKey: "category")
    }
    
    
}
