//
//  TransactionFactory.swift
//  Expenses App
//
//  Created by Daniel Halpern on 1/6/18.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation


class TransactionFactory {
    static func getTransaction(date: Date, description: String, amount: Decimal, category: String) -> Transaction {
        return Transaction(date: date, description: description, amount: amount, category: category)
    }
}
