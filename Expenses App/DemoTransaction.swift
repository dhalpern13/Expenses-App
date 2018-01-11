//
//  DemoTransaction.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-10.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class DemoTransaction {
    
    var date: String
    var description: String
    var amount: String
    
    init(date: String, description: String, amount: String) {
        self.date = date
        self.description = description
        self.amount = amount
    }
}
