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
    var individualTransactions = [String: [Transaction]]()
    var sharedTransactions = [User: [ObservableTransaction]]()
    var hashValue: Int {
        return self.userName.hashValue
    }
    
    init(name: String, userName: String) {
        self.name = name
        self.userName = userName
    }
    
    func addCategory(_ category: String) {
        if individualTransactions[category] == nil {
            individualTransactions[category] = []
        }
    }
    
    func addFriend(_ friend: User) {
        if sharedTransactions[friend] == nil  {
            sharedTransactions[friend] = []
        }
    }
    
    
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.userName == rhs.userName
}
