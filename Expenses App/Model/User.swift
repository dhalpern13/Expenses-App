//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation


class User: NSObject, NSCoding {
    
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
        if self.transactions[year]![month] == nil {
            self.transactions[year]![month] = []
        }
        self.transactions[year]![month]!.append(transaction)
        self.transactions[year]![month]!.sort()
        if(year <= earliestYearAndMonth.year) {
            self.earliestYearAndMonth.year = year;
            if(month < self.earliestYearAndMonth.month) {
                self.earliestYearAndMonth.month = month;
            }
        }
        if(year >= self.latestYearAndMonth.year) {
            self.latestYearAndMonth.year = year;
            if(month > self.latestYearAndMonth.month) {
                self.latestYearAndMonth.month = month;
            }
        }
    }
    
    func removeTransaction(_ transaction: Transaction) {
        let year = transaction.date.getYearNum()
        let month = transaction.date.getMonthNum()
        if self.transactions[year]?[month] != nil {
            self.transactions[year]![month]! = self.transactions[year]![month]!.filter() {$0 !== transaction}
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
    
    struct PropertyKey {
        static let transactions = "transactions"
        static let categories = "categories"
        static let earliestDate = "earliestDate"
        static let latestDate = "latestDate"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.transactions, forKey: PropertyKey.transactions)
        aCoder.encode(self.categories, forKey: PropertyKey.categories)
        aCoder.encode(self.earliestYearAndMonth, forKey: PropertyKey.earliestDate)
        aCoder.encode(self.latestYearAndMonth, forKey: PropertyKey.latestDate)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let transacts = aDecoder.decodeObject(forKey: PropertyKey.transactions) as? [Int : [Int : [Transaction]]] else {
            return nil
        }
        guard let cats = aDecoder.decodeObject(forKey: PropertyKey.categories) as? [String] else {
            return nil
        }
        guard let earliestDate = aDecoder.decodeObject(forKey: PropertyKey.earliestDate) as? (Int, Int) else {
            return nil
        }
        guard let latestDate = aDecoder.decodeObject(forKey: PropertyKey.latestDate) as? (Int, Int) else {
            return nil
        }
        self.init()
        self.transactions = transacts
        self.categories = cats
        self.earliestYearAndMonth = earliestDate
        self.latestYearAndMonth = latestDate
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
}
