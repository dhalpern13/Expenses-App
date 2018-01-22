//
//  IndividualExpenseCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-07.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol ViewCategoryDelegate: NSObjectProtocol {
    func didFinishViewing(_ viewCategoryController: IndividualCategoryTableViewController)
}

class IndividualCategoryTableViewController: UITableViewController, AddExpenseDelegate, EditExpenseDelegate {
    
    // MARK: Properties
    
    weak private var delegate: ViewCategoryDelegate?
    
    private var monthAndYear: (month: Int, year: Int)!
    
    private var month: Int {
        get {
            return self.monthAndYear!.month
        }
    }
    
    private var year: Int {
        get {
            return self.monthAndYear!.year
        }
    }
    
    private var transactions: [Transaction]!
    
    private var category: String?
    
    // MARK: Setup
    
    func setProperties(delegate: ViewCategoryDelegate, monthAndYear: (Int, Int), category: String?) {
        self.monthAndYear = monthAndYear
        self.delegate = delegate
        self.category = category
        if self.category != nil {
            self.transactions = self.user.getTransactionByCategory(self.category!, year: self.year, month: self.month)
            self.navigationItem.title = category
        } else {
            self.transactions = self.user.getTransactionsByYearAndMonth(year: self.year, month: self.month)
            self.navigationItem.title = "All Expenses"
        }
    }
    
    // MARK: Add Expense Delegate
    
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let newExpense = expense, newExpense.category == self.category || self.category == nil, newExpense.date.getMonthNum() == self.month, newExpense.date.getYearNum() ==  self.year {
            self.transactions.append(newExpense)
            self.transactions.sort()
            let rowOfNewExpense = self.transactions.index(of: newExpense)!
            let indexPathOfNewTransction = IndexPath(row: rowOfNewExpense, section: 0)
            self.tableView.insertRows(at: [indexPathOfNewTransction], with: .none)
        }
        addExpenseController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Edit Expense Delegate
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let editedExpense = expense {
            let originalIndexOfExpense = self.transactions.index(of: editedExpense)!
            let originalIndexPathOfExpense = IndexPath(row: originalIndexOfExpense, section: 0)
            
            if editedExpense.date.getMonthNum() == self.month && editedExpense.date.getYearNum() == self.year && (self.category == editedExpense.category || self.category == nil) {
                // Sort based on the modified attributes of the expense, and then add it back into the tableview.
                self.transactions.sort()
                let newIndexOfExpense = self.transactions.index(of: editedExpense)!
                let newIndexPathOfExpense = IndexPath(row: newIndexOfExpense, section: 0)
                self.tableView.moveRow(at: originalIndexPathOfExpense, to: newIndexPathOfExpense)
                self.tableView.reloadRows(at: [newIndexPathOfExpense], with: .none)
            } else {
                self.transactions.remove(at: originalIndexOfExpense)
                self.tableView.deleteRows(at: [originalIndexPathOfExpense], with: .none)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = self.transactions[indexPath.row]
        cell.descriptionLabel.text = transaction.descript
        cell.dateLabel.text = self.dateFormatter.string(from: transaction.date)
        cell.amountLabel.text = self.currencyAmountFormatter.string(from: transaction.amount as NSNumber)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenseToDelete = self.transactions[indexPath.row]
            self.transactions.remove(at: indexPath.row)
            self.user.removeTransaction(expenseToDelete)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveData()
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let editExpenseController = segue.destination as? AddOrEditTransactionTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            editExpenseController.setProperties(delegate: self, transactionToEdit: self.transactions[indexPath.row])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            self.delegate?.didFinishViewing(self)
        }
    }
    
    // MARK: Action
    
    @IBAction func addNewExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyBoard.instantiateViewController(withIdentifier: "AddExpenseTableViewRootController") as! UINavigationController
        let addExpenseTableViewController = rootController.viewControllers[0] as! AddOrEditTransactionTableViewController
        addExpenseTableViewController.setProperties(delegate: self, categoryToSuggest: self.category)
        self.present(rootController, animated: true, completion: nil)
    }
}
