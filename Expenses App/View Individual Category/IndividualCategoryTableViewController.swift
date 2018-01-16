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
    
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category
    }
    
    // MARK: Add Expense Delegate
    
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let newExpense = expense, newExpense.category == category {
            let rowOfNewTransaction = self.user.getIndexOfTransaction(newExpense)!
            let indexPathOfNewTransction = IndexPath(row: rowOfNewTransaction, section: 0)
            self.tableView.insertRows(at: [indexPathOfNewTransction], with: .none)
        }
        addExpenseController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Edit Expense Delegate
    
    func didBeginEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        let rowOfTransaction = self.user.getIndexOfTransaction(expense)!
        let indexPathOfTransaction = IndexPath(row: rowOfTransaction, section: 0)
        self.tableView.deleteRows(at: [indexPathOfTransaction], with: .none)
    }
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        let rowOfTransaction = self.user.getIndexOfTransaction(expense)!
        let indexPathOfTransction = IndexPath(row: rowOfTransaction, section: 0)
        self.tableView.insertRows(at: [indexPathOfTransction], with: .none)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let transactions = self.user.transactions[self.year]?[self.month] {
            return transactions.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = self.user.transactions[self.year]?[self.month]?[indexPath.row]
        cell.descriptionLabel.text = transaction!.description
        cell.dateLabel.text = self.dateFormatter.string(from: transaction!.date)
        cell.amountLabel.text = self.currencyAmountFormatter.string(from: transaction!.amount as NSNumber)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.user.deleteTransactionAtIndex(indexPath.row, year: self.year, month: self.month)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let editExpenseController = segue.destination as? AddOrEditTransactionTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            editExpenseController.transaction = self.user.transactions[self.year]?[self.month]?[indexPath.row]
            editExpenseController.editExpenseDelegate = self
        }
    }
    
    // MARK: Action
    
    @IBAction func addNewExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddOrEditExpenseTableView") as! AddOrEditTransactionTableViewController
        controller.categoryToSuggest = self.category
        controller.addExpenseDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
}
