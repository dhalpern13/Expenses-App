//
//  AppDelegate.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2017-12-16.
//  Copyright © 2017 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var user: User {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.user!
    }
    
    var dateFormatter: DateFormatter {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dateFormatter!
    }
    
    var currencyAmountFormatter: NumberFormatter {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.currencyAmountFormatter!
    }
    
    func getMonth(from int: Int) -> String {
        switch int {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "The number \(int) does not correspond to a month."
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties

    var window: UIWindow?
    
    var user: User?
    var dateFormatter: DateFormatter?
    var currencyAmountFormatter: NumberFormatter?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.user = User()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter!.dateStyle = .long
        
        self.currencyAmountFormatter = NumberFormatter()
        self.currencyAmountFormatter?.numberStyle = .currency
        self.currencyAmountFormatter?.maximumIntegerDigits = 10
        self.currencyAmountFormatter?.minimumFractionDigits = 2
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    }

