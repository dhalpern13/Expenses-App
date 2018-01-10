//
//  UserDependentViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-09.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
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
    
    var currentDate: Date {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.currentDate!
    }
}
