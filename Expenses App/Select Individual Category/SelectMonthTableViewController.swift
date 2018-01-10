//
//  SelectMonthTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-09.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class SelectMonthTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var month: String?
    var year: String?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.user.years.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let year = self.user.years[section]
        return self.user.yearToMonths[year]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.user.years[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let year = self.user.years[indexPath.section]
        let month = self.user.yearToMonths[year]![indexPath.row]
        cell.textLabel!.text = month
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.year = self.user.years[indexPath.section]
        self.month = self.user.yearToMonths[year!]![indexPath.row]
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
