//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class User: Hashable {
    
    // MARK: Properties
    
    var name: String
    var userName: String
    var individualTransactions = [String: [(Transaction, Bool)]]()
    var individualTransactionCategories = [String]()
    var sharedTransactions = [User: [(ObservableTransaction, Bool)]]()
    var hashValue: Int {
        return self.userName.hashValue
    }
    
    // MARK: Garbage Properties
    
    var years = ["2018", "2017"]
    var yearToMonths = ["2018":["January"], "2017":["December"]]
    var categories = ["Travel", "Groceries"]
    var yearToMonthsToCategoryToTransactions: [String: [String: [String: [DemoTransaction]]]]
    
    init(name: String, userName: String) {
        self.name = name
        self.userName = userName
        
        let transaction1 = DemoTransaction(date: "December 5, 2017", description: "Whole Foods", amount: "$69.99")
        let transaction2 = DemoTransaction(date: "December 20, 2017", description: "Loblaws", amount: "47.07")
        let transaction3 = DemoTransaction(date: "January 10, 2018", description: "Whole Foods", amount: "$93.46")
        let transaction4 = DemoTransaction(date: "January 1, 2018", description: "Loblaws", amount: "$101.98")
        let transaction5 = DemoTransaction(date: "December 5, 2017", description: "WestJet", amount: "$450.59")
        let transaction6 = DemoTransaction(date: "December 20, 2017", description: "Sheraton Calgary", amount: "307.89")
        let transaction7 = DemoTransaction(date: "January 2, 2018", description: "Air Canada", amount: "$1579.59")
        let transaction8 = DemoTransaction(date: "January 7, 2018", description: "Four Seasons Tahiti", amount: "$567.89")
        
        self.yearToMonthsToCategoryToTransactions = ["2017": ["December":["Grocery": [transaction1, transaction2], "Travel": [transaction5, transaction6]]], "2018": ["January": ["Grocery": [transaction3, transaction4], "Travel": [transaction7, transaction8]]]]
        
    }
    
    func addCategory(_ category: String) {
        if self.individualTransactions[category] == nil {
            self.individualTransactions[category] = []
            self.individualTransactionCategories.append(category)
        }
    }
    
    func addFriend(_ friend: User) {
        if self.sharedTransactions[friend] == nil  {
            self.sharedTransactions[friend] = []
        }
        if friend.sharedTransactions[self] == nil {
            friend.sharedTransactions[self] = []
        }
    }
    
    func addIndividualTransaction(date: Date, description: String, amount: Decimal, paidFor: Bool, category: String) {
        let toAdd = (TransactionFactory.getIndvidualTransaction(date: date, description: description, amount: amount), paidFor)
        
        // Previous implementation wasn't working, not sure why.
        if self.individualTransactions.keys.contains(category) {
            self.individualTransactions[category]!.append(toAdd)
            self.individualTransactionCategories.append(category)
        } else {
            self.individualTransactions[category] = [toAdd]
        }
    }
    
    func addDirectTransaction(date: Date, description: String, amount: Decimal, paidFor: Bool, to: User) {
        let transaction = TransactionFactory.getDirectPayment(date: date, description: description, amount: amount)
        addToSharedTransactions((transaction, paidFor), user: to)
        to.addToSharedTransactions((transaction, !paidFor), user: self)
    }
    
    func addSplitTransaction(date: Date, description: String, amount: Decimal, paidFor: User, forUsers: [User]) {
        let transaction = TransactionFactory.getDirectPayment(date: date, description: description, amount: amount)
        for user in forUsers {
            paidFor.addToSharedTransactions((transaction, true), user: user)
            user.addToSharedTransactions((transaction, false), user: paidFor)
        }
    }
    
    private func addToSharedTransactions(_ transaction: (ObservableTransaction, Bool), user: User) {
        if var userTransactions = self.sharedTransactions[user] {
            userTransactions.append(transaction)
        } else {
            self.sharedTransactions[user] = [transaction]
        }
    }
    
    func getTotalExpensesInCategory(_ category: String) -> Decimal {
        if let categoryTransactions = individualTransactions[category] {
            var total = Decimal(0)
            for (transaction, paidFor) in categoryTransactions{
                if paidFor {
                    total += transaction.amount
                } else {
                    total -= transaction.amount
                }
            }
            return total
        } else {
            return Decimal(0)
        }
    }
    
    func getTotalExpensesOfUser(_ user: User) -> Decimal {
        if let userTransactions = sharedTransactions[user] {
            var total = Decimal(0)
            for (transaction, paidFor) in userTransactions{
                if paidFor {
                    total += transaction.amount
                } else {
                    total -= transaction.amount
                }
            }
            return total
        } else {
            return Decimal(0)
        }
    }


    
    func getIndividualBalance() -> Decimal {
        var total = Decimal(0)
        for (category, _) in individualTransactions {
            total += getTotalExpensesInCategory(category)
        }
        return total
    }
    
    func getUserBalance() -> Decimal {
        var total = Decimal(0)
        for (user, _) in sharedTransactions {
            total += getTotalExpensesOfUser(user)
        }
        return total
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.userName == rhs.userName
}
