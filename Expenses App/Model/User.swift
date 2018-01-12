//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation



class User{
    
    var currentYear = Date().getYearNum()
    var currentMonth = Date().getMonthNum()
    var transactions : [Int : [Int : [Transaction]]] = [:]
    var categories : [String] = []
    
    func addCategory(_ category: String) {
        self.categories.append(category)
    }
    
    func removeCategory(_ category: String) {
        self.categories = self.categories.filter(){$0 != category}
    }
    
    func addTransaction(date: Date, description: String, amount: Decimal, category: String) {
        self.removeCategory(category)
        self.categories.insert(category, at: 0)
        let toAdd = TransactionFactory.getTransaction(date: date, description: description, amount: amount, category: category)
        self.addTransToDictionary(toAdd)
        
    }
    
    private func addTransToDictionary(_ transaction: Transaction) {
        let year = transaction.date.getYearNum()
        let month = transaction.date.getMonthNum()
        if self.transactions[year] == nil{
            self.transactions[year] = [:]
        }
        var yearTransactions = self.transactions[year]!
        if yearTransactions[month] == nil {
            yearTransactions[month] = []
        }
        var monthTransactions = yearTransactions[month]!
        monthTransactions.append(transaction)
        monthTransactions.sort()
    }
    
    func removeTransaction(_ transaction: Transaction) {
        if var monthTransactions = self.transactions[transaction.date.getYearNum()]?[transaction.date.getMonthNum()] {
            monthTransactions = monthTransactions.filter(){$0 !== transaction}
        }
    }
    
    func editTransaction(_ transaction: Transaction, date: Date, description: String, amount: Decimal, category: String) {
        self.removeTransaction(transaction)
        transaction.date = date
        transaction.description = description
        transaction.amount = amount
        transaction.category = category
        self.addTransToDictionary(transaction)
    }
    
    func setMonthAndYear(year: Int, month: Int) {
        self.currentYear = year
        self.currentMonth = month
    }
    
    func getTotalExpenses() -> Decimal {
        var total:Decimal = 0
        if let transactions = transactions[currentYear]?[currentMonth] {
            for transaction in transactions {
                total += transaction.amount
            }
        }
        return total
    }
    
    func getTotalExpensesOfCategory(_ category: String) -> Decimal {
        var total:Decimal = 0
        if let transactions = transactions[currentYear]?[currentMonth] {
            for transaction in transactions {
                if(transaction.category == category) {
                    total += transaction.amount
                }
            }
        }
        return total
    }
    
    
    func getCategoriesAlphabetized() -> [String] {
        return categories.sorted()
    }
    
    
}
