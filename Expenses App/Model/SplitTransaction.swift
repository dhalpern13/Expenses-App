//
//  SplitTransaction.swift
//  Expenses App
//
//  Created by Daniel Halpern on 1/6/18.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class SplitTransaction: ObservableTransaction {
    var waysSplit:Int
    
    init(date: Date, description: String, amount: Decimal, waysSplit: Int) {
        self.waysSplit = waysSplit
        super.init(date: date, description: description, amount: amount)
    }
    
    func getAmount() -> Decimal{
        return amount / Decimal(waysSplit)
    }
}
