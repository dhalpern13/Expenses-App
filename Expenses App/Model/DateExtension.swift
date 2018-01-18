//
//  DateExtension.swift
//  Expenses App
//
//  Created by Daniel Halpern on 1/11/18.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import Foundation

extension Date {
    
    func getMonthNum() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        let intMonth = Int(strMonth)
        return intMonth!
    }
    
    func getYearNum() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strYear = dateFormatter.string(from: self)
        let intYear = Int(strYear)
        return intYear!
    }

    func getDay() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strDay = dateFormatter.string(from: self)
        let intDay = Int(strDay)
        return intDay!
    }
}
