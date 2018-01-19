//
//  IndividualExpenseCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-07.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol ViewCategoryDelegate {
    func didFinishViewing(_ viewCategoryController: IndividualCategoryTableViewController)
}

class IndividualCategoryTableViewController: UITableViewController, AddExpenseDelegate, EditExpenseDelegate {
    
    // MARK: Properties
    
    var delegate: ViewCategoryDelegate?
    
    var monthAndYear: (month: Int, year: Int)!
    
    var transactions: [Transaction]!
    
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
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category
        
        if self.category != nil {
            self.transactions = self.user.getTransactionByCategory(self.category!, year: self.year, month: self.month)
        } else {
            self.transactions = self.user.getTransactionsByYearAndMonth(year: self.year, month: self.month)
        }
    }
    
    // MARK: Add Expense Delegate
    
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let newExpense = expense, newExpense.category == category, newExpense.date.getMonthNum() == self.month, newExpense.date.getYearNum() ==  self.year {
            self.transactions.append(newExpense)
            self.transactions.sort()
            let rowOfNewExpense = self.transactions.index(of: newExpense)!
            let indexPathOfNewTransction = IndexPath(row: rowOfNewExpense, section: 0)
            self.tableView.insertRows(at: [indexPathOfNewTransction], with: .none)
        }
        addExpenseController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Edit Expense Delegate
    
    func didBeginEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        let indexOfExpense = self.transactions.index(of: expense)!
        self.transactions.remove(at: indexOfExpense)
        let indexPathOfTransaction = IndexPath(row: indexOfExpense, section: 0)
        self.tableView.deleteRows(at: [indexPathOfTransaction], with: .none)
    }
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        let rowOfExpense = self.transactions.index(of: expense)!
        let indexPathOfTransction = IndexPath(row: rowOfExpense, section: 0)
        self.tableView.insertRows(at: [indexPathOfTransction], with: .none)
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
            editExpenseController.transactionToEdit = self.user.transactions[self.year]?[self.month]?[indexPath.row]
            editExpenseController.editExpenseDelegate = self
        }
    }
    
    // MARK: Action
    
    @IBAction func addNewExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyBoard.instantiateViewController(withIdentifier: "AddExpenseTableViewRootController") as! UINavigationController
        let addExpenseTableViewController = rootController.viewControllers[0] as! AddOrEditTransactionTableViewController
        addExpenseTableViewController.addExpenseDelegate = self
        addExpenseTableViewController.categoryToSuggest = self.category
        self.present(rootController, animated: true, completion: nil)
    }
}
