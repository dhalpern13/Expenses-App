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
    
    struct PropertyKey {
        static let date = "date"
        static let descript = "descript"
        static let amount = "amount"
        static let category = "category"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: PropertyKey.date)
        aCoder.encode(self.descript, forKey: PropertyKey.descript)
        aCoder.encode(self.amount, forKey: PropertyKey.amount)
        aCoder.encode(self.category, forKey: PropertyKey.category)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            return nil
        }
        guard let decsript = aDecoder.decodeObject(forKey: PropertyKey.descript) as? String else {
            return nil
        }
        guard let amount = aDecoder.decodeObject(forKey: PropertyKey.amount) as? Decimal else {
            return nil
        }
        guard let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String else {
            return nil
        }
        self.init(date: date, descript: decsript, amount: amount, category: category)
        
    }
    
    
}
