//
//  SelectCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-07.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class ViewAllCategoriesTableViewController: UITableViewController, SelectMonthDelegate, AddExpenseDelegate, ViewCategoryDelegate {
    
    // MARK: Properties
    
    var monthAndYear: (month: Int, year: Int)? {
        didSet {
            if oldValue?.month != self.monthAndYear?.month || oldValue?.year != self.monthAndYear?.year {
                self.tableView?.reloadData()
            }
        }
    }
    
    var monthString: String {
        get {
            return self.getMonth(from: self.monthAndYear!.month)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.month == nil || self.year == nil {
            let currentDate = Date()
            self.month = currentDate.getMonthNum()
            self.year = currentDate.getYearNum()
        }
        
        loadTitle()
    }
    
    // MARK: Select Month Delegate
    
    func didFinishSelecting(_ selectMonthController: SelectMonthTableViewController, month: Int?, year: Int?) {
        if let newMonth = month, let newYear = year {
            self.monthAndYear = (newMonth, newYear)
        }
        selectMonthController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Add Expense Delegate
    
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let newExepense = expense {
            // This should be modified to only reload the cells that have changed.
            self.tableView.reloadData()
        }
        addExpenseController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Category Delegate
    
    func didFinishViewing(_ viewCategoryController: IndividualCategoryTableViewController) {
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Load Title
    
    func loadTitle() {
        let monthLabel = UILabel()
        monthLabel.text = self.monthString + " \(self.monthAndYear!.year)"
        monthLabel.font = UIFont.boldSystemFont(ofSize: 17)
        monthLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [monthLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = monthLabel.frame.size.width
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        self.navigationItem.title = self.monthString + " \(self.monthAndYear!.year)"
        self.navigationItem.titleView = stackView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(respondToMonthLabelTap))
        tapRecognizer.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapRecognizer)
        stackView.isUserInteractionEnabled = true
    }

    // MARK: UITableViewDelegate

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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Total"
            cell.detailTextLabel!.text = "$1,100"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let category = self.user.categories[indexPath.row]
            cell.textLabel!.text = category
            cell.detailTextLabel!.text = "$1,000"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete category from back end
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let individualCategoryViewController = segue.destination as? IndividualCategoryTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            // individualCategoryViewController.category = the category of the index
            individualCategoryViewController.monthAndYear = self.monthAndYear!
            individualCategoryViewController.delegate = self
        }
    }
    
    // MARK: Actions
    
    @objc func respondToMonthLabelTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "SelectMonthTableView") as! SelectMonthTableViewController
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func addNewExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddOrEditExpenseTableView") as! AddOrEditTransactionTableViewController
        controller.addExpenseDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
}
