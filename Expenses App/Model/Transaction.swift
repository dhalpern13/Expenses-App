//
//  Transaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class Transaction: Comparable, Codable{
    
    
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
    
    enum CodingKeys: String, CodingKey {
        case date
        case descript
        case amount
        case category
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(descript, forKey: .descript)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        descript = try values.decode(String.self, forKey: .descript)
        amount = try values.decode(Decimal.self, forKey: .amount)
        category = try values.decode(String.self, forKey: .category)
    }
    
    
}
