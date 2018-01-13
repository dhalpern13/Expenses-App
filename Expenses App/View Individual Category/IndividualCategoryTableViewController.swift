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
    
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category
    }
    
    // MARK: Add Expense Delegate
    
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?) {
        if let newExpense = expense {
            if newExpense.category == category {
                self.tableView.reloadData()
            }
        }
        addExpenseController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Edit Expense Delegate
    
    func didBeginEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        // get index of transaction from user, and then delete the transactions
    }
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction) {
        // get new index of transaction, and then re-insert it into the table view
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionTableViewCell else {
            fatalError("Cell was not of type TransactionTableViewCell")
        }
        
        let transaction = user.yearToMonthsToCategoryToTransactions["2018"]!["January"]![category]![indexPath.row]
        cell.descriptionLabel.text = transaction.description
        cell.dateLabel.text = transaction.date
        cell.amountLabel.text = transaction.amount
            
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let editExpenseController = segue.destination as? AddOrEditTransactionTableViewController {
            // editExpenseViewController.transaction = the cell
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
