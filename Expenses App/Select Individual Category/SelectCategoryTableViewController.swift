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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return user.yearToMonthsToCategoryToTransactions[year]![month]!.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IndividualCategoryTableViewCell"
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let category = self.user.categories[indexPath.row]
            cell.textLabel!.text = category
            cell.detailTextLabel!.text = "$1,000"
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Uncategorized"
            cell.detailTextLabel!.text = "$100"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Total"
            cell.detailTextLabel!.text = "$1,100"
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
        
        if let individualCategoryViewController = segue.destination as? IndividualExpenseCategoryTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            
            switch indexPath.section {
            case 0:
                individualCategoryViewController.category = "All Expenses"
            case 1:
                individualCategoryViewController.category = self.user.categories[indexPath.row]
            case 2:
                individualCategoryViewController.category = "Uncategorized"
            default:
                fatalError("There should not be a section with index \(indexPath.section) in this Table View.")
            }
        }
    }
    
    @IBAction func unwindToCategorySelection(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SelectMonthTableViewController, let month = sourceViewController.month, let year = sourceViewController.year {
            self.month = month
            self.year = year
            self.tableView.reloadData()
            loadTitle()
        } else if sender.source is IndividualExpenseCategoryTableViewController {
            // If the user added a new expense while in this view, other categories could have different totals, and there could be new categories, so it seems
            // safest to just reload.
            self.tableView.reloadData()
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
}
