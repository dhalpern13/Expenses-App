//
//  ObservableTransaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 1/6/18.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class ObservableTransaction: Transaction {
    
    override init(date: Date, description: String, amount: Decimal) {
        super.init(date: date, description: description, amount: amount)
    }
}
