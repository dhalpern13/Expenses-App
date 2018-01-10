//
//  TransactionFactory.swift
//  Expenses App
//
//  Created by Daniel Halpern on 1/6/18.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation


class TransactionFactory {
    static func getIndvidualTransaction(date: Date, description: String, amount: Decimal) -> Transaction {
        return Transaction(date: date, description: description, amount: amount)
    }
    
    static func getDirectPayment(date: Date, description: String, amount: Decimal) -> ObservableTransaction {
        return ObservableTransaction(date: date, description: description, amount: amount)
    }
    
    static func getSplitPayment(date: Date, description: String, amount: Decimal, waysSplit: Int) -> SplitTransaction {
        return SplitTransaction(date: date, description: description, amount: amount, waysSplit: waysSplit)
    }
}
