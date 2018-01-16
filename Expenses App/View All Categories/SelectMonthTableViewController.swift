//
//  SelectMonthTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-09.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol SelectMonthDelegate {
    func didFinishSelecting(_ selectMonthController: SelectMonthTableViewController, month: Int?, year: Int?)
}

class SelectMonthTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var delegate: SelectMonthDelegate?
    
    var month: Int?
    
    var year: Int?
    
    var startMonth: Int!
    
    var startYear: Int!
    
    var currentMonth = Date().getMonthNum()
    
    var currentYear = Date().getYearNum()
    
    override func viewDidLoad() {
        self.startMonth = self.user.earliestYearAndMonth.month
        self.startYear = self.user.earliestYearAndMonth.year
    }

    // MARK: UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        let currentYear = Date().getYearNum()
        return currentYear - self.startYear + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.currentMonth
        } else if self.startYear - section == 0 {
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
        let yearOfSection = self.currentYear - indexPath.section
        if yearOfSection == self.currentYear || yearOfSection > self.startYear {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel!.text = self.getMonth(from: indexPath.row + 1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            let monthNumber = self.startMonth + indexPath.row
            cell.textLabel!.text = self.getMonth(from: monthNumber)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.year = self.currentYear - indexPath.section
        
        if self.year == self.currentYear {
            self.month = self.currentMonth - indexPath.row
        } else {
            self.month = 12 - indexPath.row
        }
        // dont store return values as attributes
        self.delegate?.didFinishSelecting(self, month: self.month, year: self.year)
    }
    
    // MARK: Action
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.didFinishSelecting(self, month: self.month, year: self.year)
    }
}
