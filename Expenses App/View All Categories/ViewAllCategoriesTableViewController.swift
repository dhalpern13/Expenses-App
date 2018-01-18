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
            if oldValue != nil && (oldValue?.month != self.monthAndYear?.month || oldValue?.year != self.monthAndYear?.year) {
                self.tableView?.reloadData()
            }
        }
    }
    
    var monthAndYearString: String {
        get {
            return self.getMonth(from: self.month) + " \(self.year)"
        }
    }
    
    var month: Int {
        get {
            return self.monthAndYear!.month
        }
    }
    
    var year: Int {
        get {
           return self.monthAndYear!.year
        }
    }
    
    var categories: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.monthAndYear?.month == nil || self.monthAndYear?.year == nil {
            let currentDate = Date()
            self.monthAndYear = (currentDate.getMonthNum(), currentDate.getYearNum())
        }
        
        self.categories = self.user.getCategoriesAlphabetized()
        
        self.categories = self.categories!.filter({ (category) -> Bool in
            if self.user.getTotalExpensesOfCategory(category, year: self.year, month: self.month) > 0 {
                return true
            } else {
                return false
            }
        })
        
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
            
            let categoryOfNewExpense = newExepense.category
            
            if let rowOfCategory = self.categories!.index(of: categoryOfNewExpense) {
                let indexPathOfCategory = IndexPath(row: rowOfCategory, section: 0)
                self.tableView.reloadRows(at: [indexPathOfCategory], with: .none)
            } else {
                self.categories.append(categoryOfNewExpense)
                self.categories.sort()
                let rowOfCategory = self.categories.index(of: categoryOfNewExpense)!
                let indexPathOfCategory = IndexPath(row: rowOfCategory, section: 0)
                self.tableView.insertRows(at: [indexPathOfCategory], with: .none)
            }
        
            let indexPathOfTotalRow = IndexPath(row: 0, section: 1)
            self.tableView.reloadRows(at: [indexPathOfTotalRow], with: .none)
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
        monthLabel.text = self.monthAndYearString
        monthLabel.font = UIFont.boldSystemFont(ofSize: 17)
        monthLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [monthLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = monthLabel.frame.size.width
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        self.navigationItem.title = self.monthAndYearString
        self.navigationItem.titleView = stackView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(respondToMonthLabelTap))
        tapRecognizer.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapRecognizer)
        stackView.isUserInteractionEnabled = true
    }

    // MARK: UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.categories.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IndividualCategoryTableViewCell"
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let category = self.categories[indexPath.row]
            cell.textLabel!.text = category
            let totalForCategory = self.user.getTotalExpensesOfCategory(category, year: self.year, month: self.month)
            cell.detailTextLabel!.text = self.currencyAmountFormatter.string(from: totalForCategory as NSNumber)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = "Total"
            let total = self.user.getTotalExpenses(year: self.year, month: self.month)
            cell.detailTextLabel!.text = self.currencyAmountFormatter.string(from: total as NSNumber)
            return cell
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let individualCategoryViewController = segue.destination as? IndividualCategoryTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            individualCategoryViewController.category = self.categories[indexPath.row]
            individualCategoryViewController.monthAndYear = self.monthAndYear!
            individualCategoryViewController.delegate = self
        }
    }
    
    // MARK: Actions
    
    @objc func respondToMonthLabelTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyBoard.instantiateViewController(withIdentifier: "SelectMonthTableViewRootController") as! UINavigationController
            let selectMonthTableViewController = rootController.viewControllers[0] as! SelectMonthTableViewController
            selectMonthTableViewController.delegate = self
            self.present(rootController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyBoard.instantiateViewController(withIdentifier: "AddExpenseTableViewRootController") as! UINavigationController
        let addExpenseTableViewController = rootController.viewControllers[0] as! AddOrEditTransactionTableViewController
        addExpenseTableViewController.addExpenseDelegate = self
        self.present(rootController, animated: true, completion: nil)
    }
}
