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
    
    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveUserData()
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
        if let savedUser = loadUserData() {
            self.user = savedUser
        } else {
            self.user = User()
        }
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter!.dateStyle = .long
        
        self.currencyAmountFormatter = NumberFormatter()
        self.currencyAmountFormatter?.numberStyle = .currency
        self.currencyAmountFormatter?.maximumIntegerDigits = 10
        self.currencyAmountFormatter?.minimumFractionDigits = 2
        self.currencyAmountFormatter?.maximumFractionDigits = 2
        
        return true
    }
    
    func saveUserData() {
        if user != nil {
            do {
                let data = try PropertyListEncoder().encode(user!)
                let success = NSKeyedArchiver.archiveRootObject(data, toFile: User.ArchiveURL.path)
                print(success ? "Successful save" : "Save Failed")
            } catch {
                print("Save Failed")
            }
        }
    }
    
    private func loadUserData() -> User? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? Data else { return nil }
        do {
            let newUser = try PropertyListDecoder().decode(User.self, from: data)
            return newUser
        } catch {
            print("Retrieve Failed")
            return nil
        }
    }
}

