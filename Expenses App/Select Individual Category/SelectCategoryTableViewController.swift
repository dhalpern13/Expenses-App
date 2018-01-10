//
//  SelectCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-07.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class SelectCategoryTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var month: String!
    var year: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.month == nil || self.year == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            self.month = dateFormatter.string(from: self.currentDate)
            dateFormatter.dateFormat = "yyyy"
            self.year = dateFormatter.string(from: self.currentDate)
        }
        
        loadTitle()
    }
    
    // MARK: Load Title
    
    func loadTitle() {
        let monthLabel = UILabel()
        monthLabel.text = self.month + " " + self.year
        monthLabel.font = UIFont.boldSystemFont(ofSize: 17)
        monthLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [monthLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = monthLabel.frame.size.width
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        self.navigationItem.title = self.month + " " + self.year
        self.navigationItem.titleView = stackView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(respondToMonthLabelTap))
        tapRecognizer.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapRecognizer)
        stackView.isUserInteractionEnabled = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Categories"
        default:
            return " "
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return user.individualTransactionCategories.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IndividualCategoryTableViewCell"
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let category = self.user.individualTransactionCategories[indexPath.row]
            cell.textLabel!.text = category
            cell.detailTextLabel!.text = "$" + self.user.getTotalExpensesInCategory(category).description
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Uncategorized"
            cell.detailTextLabel!.text = "$100"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Total"
            cell.detailTextLabel!.text = "$1000"
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let individualCategoryTableView = segue.destination as? IndividualExpenseCategoryTableViewController {
            let selectedIndex = tableView.indexPathForSelectedRow!
            
            if selectedIndex.section == 1 {
                let selectedCategory = self.user.individualTransactionCategories[selectedIndex.row]
                individualCategoryTableView.category = selectedCategory
            } else {
                // Handle where the user selects the uncategorized expenses.  Needs to be fixed.
                let selectedCategory = self.user.individualTransactionCategories[0]
                individualCategoryTableView.category = selectedCategory
            }
        }
    }
    
    // MARK: Actions
    
    @objc func respondToMonthLabelTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "selectMonthTableViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToCategorySelection(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SelectMonthTableViewController, let month = sourceViewController.month, let year = sourceViewController.year {
            self.month = month
            self.year = year
            // Methods for loading data need to be changed to reference the values of month and year.
            tableView.reloadData()
            loadTitle()
        }
    }
}
