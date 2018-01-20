//
//  SelectMonthTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-09.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol SelectMonthDelegate: NSObjectProtocol {
    func didFinishSelecting(_ selectMonthController: SelectMonthTableViewController, month: Int?, year: Int?)
}

class SelectMonthTableViewController: UITableViewController {
    
    // MARK: Properties
    
    weak private var delegate: SelectMonthDelegate?
    
    private var startMonth: Int {
        get {
            return self.user.earliestYearAndMonth.month
        }
    }
    
    private var startYear: Int {
        get {
            return self.user.earliestYearAndMonth.year
        }
    }
    
    private var currentMonth = Date().getMonthNum()
    
    private var currentYear = Date().getYearNum()
    
    // MARK: Setup
    
    func setProperties(delegate: SelectMonthDelegate) {
        self.delegate = delegate
    }

    // MARK: UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        let currentYear = Date().getYearNum()
        return currentYear - self.startYear + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let year = self.currentYear - section
        if year == self.currentYear {
            return self.currentMonth
        } else if year == self.startYear {
            return 12 - self.startMonth + 1
        } else {
            return 12
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let yearOfSection = self.currentYear - section
        return yearOfSection.description
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let year = self.currentYear - indexPath.section
        if year == self.currentYear {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel!.text = self.getMonth(from: self.currentMonth - indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel!.text = self.getMonth(from: 12 - indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let year = self.currentYear - indexPath.section
        
        var month: Int
        if year == self.currentYear {
            month = self.currentMonth - indexPath.row
        } else {
            month = 12 - indexPath.row
        }
        self.delegate?.didFinishSelecting(self, month: month, year: year)
    }
    
    // MARK: Action
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.didFinishSelecting(self, month: nil, year: nil)
    }
}
