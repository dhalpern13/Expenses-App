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
    
    var numberFormatter = NumberFormatter()
    
    var transactionToEdit: Transaction?
    
    var categoryToSuggest: String?
    
    var date: Date! {
        didSet {
            self.dateTableViewCell?.detailTextLabel?.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    var transactionDescriptionIsValid: Bool {
        get {
            return self.transactionDescription != nil && !self.transactionDescription!.isEmpty
        }
    }
    
    var transactionDescription: String? {
        didSet {
            if self.transactionDescriptionIsValid {
                self.descriptionTableViewCell?.textField.textColor = nil
            } else {
                self.descriptionTableViewCell?.textField.textColor = UIColor.lightGray
            }
            self.updateSaveButtonState()
        }
    }
    
    var categoryIsValid: Bool {
        get {
            return self.category != nil && !self.category!.isEmpty
        }
    }
    
    var category: String? {
        didSet {
            self.selectCategoryTableViewCell?.detailTextLabel?.text = self.category
            self.selectCategoryTableViewCell?.detailTextLabel?.textColor = nil
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
            if self.amount != nil {
                self.amountTableViewCell?.amountTextEntry.text = self.currencyAmountFormatter.string(from: self.amount! as NSNumber)
            }
            self.updateSaveButtonState()
        }
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
            if self.amount != nil {
                newValue?.amountTextEntry.text = self.currencyAmountFormatter.string(from: self.amount! as NSNumber)
            }
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
        } else if !self.transactionDescriptionIsValid {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isEnabled = false
        
        self.hideKeyboardWhenAnywhereInViewTapped()
        
        if self.transactionToEdit == nil {
            self.navigationItem.title = "New Expense"
            self.date = Date()
            if categoryToSuggest != nil {
                self.category = self.categoryToSuggest!
            }
        } else {
            self.navigationItem.title = ""
            self.amount = transactionToEdit!.amount
            self.category = transactionToEdit!.category
            self.transactionDescription = transactionToEdit!.description
            self.date = transactionToEdit!.date
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.editExpenseDelegate?.didBeginEditing(self, expense: self.transactionToEdit!)
    }
    
    // MARK: Select Category Delegate
    
    func didFinishSelecting(_ selectCategoryController: SelectCategoryTableViewController, category: String?) {
        if let newCategory = category {
            self.category = newCategory
        }
        self.navigationController?.popViewController(animated: true)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            self.descriptionTableViewCell = cell
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountTableViewCell", for: indexPath) as! AmountTableViewCell
            self.amountTableViewCell = cell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectCategoryTableViewCell", for: indexPath)
            self.selectCategoryTableViewCell = cell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.handleTableDateTableViewCellTap()
        } else if indexPath.section == 3 {
            self.datePickerVisible = false
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0 {
            return true
        } else if indexPath.section == 3 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveButton.isEnabled = false
        self.datePickerVisible = false
        if textField.tag == 0 {
            self.amountTableViewCell?.amountTextEntry.text = self.amount?.description
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if replacementText.isEmpty {
                return true
            }
            else {
                if self.numberFormatter.number(from: replacementText) != nil {
                    let split = replacementText.components(separatedBy: ".")
                    if split.count == 2 {
                        let decimalDigits = split.last!
                        return decimalDigits.count <= 2
                    } else {
                        return true
                    }
                } else {
                    return false
                }
            }
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.amount = Decimal(string: textField.text ?? "")
        } else {
            self.transactionDescription = textField.text
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let selectCategoryTableViewController = segue.destination as? SelectCategoryTableViewController {
            selectCategoryTableViewController.delegate = self
        }
    }
    
    // MARK: Actions
    
    @objc func handleDatePickerValueChange() {
        self.date = self.datePickerTableViewCell?.datePicker.date
    }
    
    func handleTableDateTableViewCellTap() {
        self.datePickerVisible = !self.datePickerVisible
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.addExpenseDelegate?.didFinishAdding(self, expense: nil)
        self.editExpenseDelegate?.didFinishEditing(self, expense: self.transactionToEdit!)
    }
    
    @IBAction func save(_ sender: Any) {
        if self.transactionToEdit != nil {
            self.user.editTransaction(self.transactionToEdit!, date: self.date, description: self.description, amount: self.amount!, category: self.category!)
            self.editExpenseDelegate?.didFinishEditing(self, expense: self.transactionToEdit!)
        } else {
            let newTransaction = self.user.addTransaction(date: self.date, description: self.transactionDescription!, amount: self.amount!, category: self.category!)
            self.addExpenseDelegate?.didFinishAdding(self, expense: newTransaction)
        }
    }
}



