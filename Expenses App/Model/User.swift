//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation


class User: Codable {
    
    var transactions : [Int : [Int : [Transaction]]] = [:]
    var categories : [String] = []
    var earliestYearAndMonth : (year: Int, month: Int) = (Date().getYearNum(), Date().getMonthNum());
    var latestYearAndMonth : (year: Int, month: Int) = (Date().getYearNum(), Date().getMonthNum());
    
    init(){}
    
    func addCategory(_ category: String) {
        self.removeCategory(category)
        categories.insert(category, at: 0)
    }
    
    func removeCategory(_ category: String) {
        self.categories = self.categories.filter(){$0 != category}
    }
    
    func addTransaction(date: Date, descript: String, amount: Decimal, category: String) -> Transaction {
        self.addCategory(category)
        let toAdd = TransactionFactory.getTransaction(date: date, descript: descript, amount: amount, category: category)
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
        self.transactions[year]![month]! = self.transactions[year]![month]!.sorted()
        if(year <= earliestYearAndMonth.year) {
            if(month < self.earliestYearAndMonth.month || year < earliestYearAndMonth.year) {
                self.earliestYearAndMonth.month = month;
            }
            self.earliestYearAndMonth.year = year;
        }
        if(year >= self.latestYearAndMonth.year) {
            if(month > self.latestYearAndMonth.month || year > earliestYearAndMonth.year) {
                self.latestYearAndMonth.month = month;
            }
            self.latestYearAndMonth.year = year;
        }
    }
    
    func removeTransaction(_ transaction: Transaction) {
        let year = transaction.date.getYearNum()
        let month = transaction.date.getMonthNum()
        if self.transactions[year]?[month] != nil {
            self.transactions[year]![month]! = self.transactions[year]![month]!.filter() {$0 !== transaction}
        }
    }
    
    func editTransaction(_ transaction: Transaction, date: Date, descript: String, amount: Decimal, category: String) {
        self.removeTransaction(transaction)
        transaction.date = date
        transaction.descript = descript
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
    
    enum CodingKeysUser: String, CodingKey {
        case transactions
        case categories
        case earliestMonth
        case earliestYear
        case latestMonth
        case latestYear
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysUser.self)
        try container.encode(transactions, forKey: .transactions)
        try container.encode(categories, forKey: .categories)
        try container.encode(earliestYearAndMonth.month, forKey: .earliestMonth)
        try container.encode(earliestYearAndMonth.year, forKey: .earliestYear)
        try container.encode(latestYearAndMonth.month, forKey: .latestMonth)
        try container.encode(latestYearAndMonth.year, forKey: .latestYear)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeysUser.self)
        transactions = try values.decode([Int : [Int : [Transaction]]].self, forKey: .transactions)
        categories = try values.decode([String].self, forKey: .categories)
        let earliestMonth = try values.decode(Int.self, forKey: .earliestMonth)
        let earliestYear = try values.decode(Int.self, forKey: .earliestYear)
        earliestYearAndMonth = (earliestYear, earliestMonth)
        let latestMonth = try values.decode(Int.self, forKey: .latestMonth)
        let latestYear = try values.decode(Int.self, forKey: .latestYear)
        latestYearAndMonth = (latestYear, latestMonth)
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
}
