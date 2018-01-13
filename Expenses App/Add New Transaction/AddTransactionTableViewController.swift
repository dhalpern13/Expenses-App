//
//  AddOrEditTransactionTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-10.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol EditExpenseDelegate {
    func didBeginEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction)
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction)
}

protocol AddExpenseDelegate {
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?)
}

class AddOrEditTransactionTableViewController: UITableViewController, UITextFieldDelegate, SelectCategoryDelegate {

    // MARK: Properties
    
    var addExpenseDelegate: AddExpenseDelegate?
    
    var editExpenseDelegate: EditExpenseDelegate?
    
    var transaction: Transaction?
    
    var categoryToSuggest: String?
    
    var date: Date! {
        didSet {
            self.dateTableViewCell?.detailTextLabel?.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    var transactionDescription: String?
    
    var categoryIsValid: Bool {
        get {
            return self.category != nil
        }
    }
    
    var category: String? {
        didSet {
            self.selectCategoryTableViewCell?.detailTextLabel?.text = category
            self.updateSaveButtonState()
        }
    }
    
    var amountIsValid: Bool {
        get {
            return self.amount != nil && self.amount! > 0
        }
    }
    
    var amount: Decimal? {
        didSet {
            self.updateSaveButtonState()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.editExpenseDelegate?.didBeginEditing(self, expense: self.transaction!)
    }
    
    // MARK: Properties - UI Items
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dateTableViewCell: UITableViewCell? {
        willSet {
            newValue?.detailTextLabel?.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    var datePickerVisible = false {
        didSet {
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    var datePickerTableViewCell: DatePickerTableViewCell? {
        willSet {
            newValue?.datePicker.setDate(self.date, animated: false)
            newValue?.datePicker.maximumDate = Date()
            newValue?.datePicker.addTarget(self, action: #selector(handleDatePickerValueChange), for: .valueChanged)
        }
    }
    
    var amountTableViewCell: AmountTableViewCell? {
        willSet {
            let amountToDisplay = self.amount! as NSDecimalNumber
            newValue?.amountTextEntry.text = self.amountTextEntryFormatter.string(from: amountToDisplay)
            newValue?.amountTextEntry.delegate = self
            newValue?.amountTextEntry.tag = 0
        }
    }
    
    var descriptionTableViewCell: DescriptionTableViewCell? {
        willSet {
            newValue?.textField.text = self.transactionDescription
            newValue?.textField.delegate = self
            newValue?.textField.tag = 1
        }
    }
    
    var selectCategoryTableViewCell: UITableViewCell? {
        willSet {
            newValue?.detailTextLabel?.text = self.category
        }
    }
    
    func updateSaveButtonState() {
        if !self.categoryIsValid {
            self.saveButton.isEnabled = false
        } else if !self.amountIsValid {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isEnabled = false
        
        if transaction == nil {
            self.navigationItem.title = "New Expense"
            self.date = Date()
            if categoryToSuggest != nil {
                self.category = nil
            }
        } else {
            self.amount = transaction!.amount
            self.category = transaction!.category
            self.transactionDescription = transaction!.description
            self.date = transaction!.date
        }
    }
    
    // MARK: Select Category Delegate
    
    func didFinishSelecting(_ selectCategoryController: SelectCategoryTableViewController, category: String?) {
        if let newCategory = category {
            self.category = newCategory
        }
        selectCategoryController.dismiss(animated: true, completion: nil)
    }

    // MARK: UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.datePickerVisible {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateTableViewCell", for: indexPath)
                self.dateTableViewCell = cell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
                self.datePickerTableViewCell = cell
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountTableViewCell", for: indexPath) as! AmountTableViewCell
            self.amountTableViewCell = cell
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectCategoryTableViewCell", for: indexPath)
            self.selectCategoryTableViewCell = cell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            self.descriptionTableViewCell = cell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            self.handleTableDateTableViewCellTap()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && indexPath.row == 0 {
            return true
        } else if indexPath.section == 2 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveButton.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let validAmount = self.currencyAmountFormatter.number(from: string)
            textField.text = self.currencyAmountFormatter.string(from: validAmount!)
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.amount = self.currencyAmountFormatter.number(from: textField.text!) as? Decimal
        } else {
            self.transactionDescription = textField.text
        }
    }
    
    // MARK: Actions
    
    @objc func handleDatePickerValueChange() {
        self.date = self.datePickerTableViewCell?.datePicker.date
    }
    
    func handleTableDateTableViewCellTap() {
        self.datePickerVisible = !self.datePickerVisible
    }
    
    @IBAction func handleCancelButtonPress(_ sender: Any) {
        self.addExpenseDelegate?.didFinishAdding(self, expense: self.transaction)
        self.editExpenseDelegate?.didFinishEditing(self, expense: self.transaction!)
    }
    
    @IBAction func handleSaveButtonPress(_ sender: Any) {
        if self.transaction != nil {
            self.user.editTransaction(self.transaction!, date: self.date, description: self.description, amount: self.amount!, category: self.category!)
            self.editExpenseDelegate?.didFinishEditing(self, expense: self.transaction!)
        } else {
            // self.transaction = new transaction
            // create and return?
            self.addExpenseDelegate?.didFinishAdding(self, expense: self.transaction)
        }
    }
    
}



