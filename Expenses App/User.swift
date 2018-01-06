//
//  User.swift
//  Expenses App
//
//  Created by Daniel Halpern on 12/26/17.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

class User: Hashable {
    var name: String
    var userName: String
    var individualTransactions = [String: [(Transaction, Bool)]]()
    var sharedTransactions = [User: [(ObservableTransaction, Bool)]]()
    var hashValue: Int {
        return self.userName.hashValue
    }
    
    init(name: String, userName: String) {
        self.name = name
        self.userName = userName
    }
    
    func addCategory(_ category: String) {
        if self.individualTransactions[category] == nil {
            self.individualTransactions[category] = []
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
        if var categoryTransactions = self.individualTransactions[category] {
            categoryTransactions.append(toAdd)
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
