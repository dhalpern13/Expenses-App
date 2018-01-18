//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation



class User {
    
    var transactions : [Int : [Int : [Transaction]]] = [:]
    var categories : [String] = []
    var earliestYearAndMonth : (year: Int, month: Int) = (Date().getYearNum(), Date().getMonthNum());
    var latestYearAndMonth : (year: Int, month: Int) = (Date().getYearNum(), Date().getMonthNum());
    
    
    func addCategory(_ category: String) {
        self.categories.append(category)
    }
    
    func removeCategory(_ category: String) {
        self.categories = self.categories.filter(){$0 != category}
    }
    
    func addTransaction(date: Date, description: String, amount: Decimal, category: String) -> Transaction {
        self.removeCategory(category)
        self.categories.insert(category, at: 0)
        let toAdd = TransactionFactory.getTransaction(date: date, description: description, amount: amount, category: category)
        self.addTransToDictionary(toAdd)
        return toAdd
    }
    
    func getTransactionsByYearAndMonth(year: Int, month: Int) -> [Transaction]{
        if transactions[year]?[month] == nil {
            return [];
        } else {
            return transactions[year]![month]!
        }
    }
    
    func getTransactionByCategory(_ category: String, year: Int, month: Int) -> [Transaction] {
        var transactions: [Transaction] = []
        if let monthTransactions = self.transactions[year]?[month] {
            for transaction in monthTransactions {
                if transaction.category == category {
                    transactions.append(transaction)
                }
            }
        }
        return transactions
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
        if(year <= earliestYearAndMonth.year) {
            earliestYearAndMonth.year = year;
            if(month < earliestYearAndMonth.month) {
                earliestYearAndMonth.month = month;
            }
        }
        if(year >= latestYearAndMonth.year) {
            latestYearAndMonth.year = year;
            if(month > latestYearAndMonth.month) {
                latestYearAndMonth.month = month;
            }
        }
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
    
    
    func getTotalExpenses(year: Int, month: Int) -> Decimal {
        var total:Decimal = 0
        if let transactions = transactions[year]?[month] {
            for transaction in transactions {
                total += transaction.amount
            }
        }
        return total
    }
    
    func getTotalExpensesOfCategory(_ category: String, year: Int, month: Int) -> Decimal {
        var total:Decimal = 0
        if let transactions = self.transactions[year]?[month] {
            for transaction in transactions {
                if(transaction.category == category) {
                    total += transaction.amount
                }
            }
        }
        return total
    }
    
    func getCategoriesByYearAndMonth(year: Int, month: Int) -> [String] {
        var cats:Set<String> = []
        if let transactions = self.transactions[year]?[month] {
            for transaction in transactions {
                cats.insert(transaction.category)
            }
        }
        let arrCats = Array(cats)
        return arrCats.sorted()
    }    
}
