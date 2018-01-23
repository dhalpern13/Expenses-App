//
//  AddOrEditTransactionTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-10.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol EditExpenseDelegate: NSObjectProtocol {
    
    func didFinishEditing(_ editExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?)
}

protocol AddExpenseDelegate: NSObjectProtocol {
    func didFinishAdding(_ addExpenseController: AddOrEditTransactionTableViewController, expense: Transaction?)
}

class AddOrEditTransactionTableViewController: UITableViewController, UITextFieldDelegate, SelectCategoryDelegate {

    // MARK: Properties
    
    weak private var addExpenseDelegate: AddExpenseDelegate?
    
    weak private var editExpenseDelegate: EditExpenseDelegate? 
    
    private var numberFormatter = NumberFormatter()
    
    private var transactionToEdit: Transaction?
    
    private var date: Date! {
        didSet {
            self.dateTableViewCell?.textLabel?.text = self.dateFormatter.string(from: self.date)
            self.updateSaveButtonState()
        }
    }
    
    private var transactionDescriptionIsValid: Bool {
        get {
            return self.transactionDescription != nil && !self.transactionDescription!.isEmpty
        }
    }
    
    private var transactionDescription: String? {
        didSet {
            self.updateSaveButtonState()
        }
    }
    
    private var categoryIsValid: Bool {
        get {
            return self.category != nil && !self.category!.isEmpty
        }
    }
    
    private var category: String? {
        didSet {
            self.selectCategoryTableViewCell?.textLabel?.text = self.category
            self.selectCategoryTableViewCell?.textLabel?.textColor = nil
            self.updateSaveButtonState()
        }
    }
    
    private var amountIsValid: Bool {
        get {
            return self.amount != nil && self.amount! > 0
        }
    }
    
    private var amount: Decimal? {
        didSet {
            if self.amount != nil {
                self.amountTableViewCell?.amountTextEntry.text = self.currencyAmountFormatter.string(from: self.amount! as NSNumber)
            }
            self.updateSaveButtonState()
        }
    }
    
    // MARK: Properties - UI Items
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var dateTableViewCell: UITableViewCell? {
        willSet {
            newValue?.textLabel?.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    private var datePickerVisible = false {
        didSet {
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    private var datePickerTableViewCell: DatePickerTableViewCell? {
        willSet {
            newValue?.datePicker.setDate(self.date, animated: false)
            newValue?.datePicker.maximumDate = Date()
            newValue?.datePicker.addTarget(self, action: #selector(handleDatePickerValueChange), for: .valueChanged)
        }
    }
    
    private var amountTableViewCell: AmountTableViewCell? {
        willSet {
            if self.amount != nil {
                newValue?.amountTextEntry.text = self.currencyAmountFormatter.string(from: self.amount! as NSNumber)
            }
            newValue?.amountTextEntry.delegate = self
            newValue?.amountTextEntry.tag = 0
        }
    }
    
    private var descriptionTableViewCell: DescriptionTableViewCell? {
        willSet {
            newValue?.textField.text = self.transactionDescription
            newValue?.textField.delegate = self
            newValue?.textField.tag = 1
        }
    }
    
    private var selectCategoryTableViewCell: UITableViewCell? {
        willSet {
            if self.category != nil {
                newValue?.textLabel?.text = self.category
                newValue?.textLabel?.textColor = nil
            }
        }
    }
    
    // MARK: Setup
    
    func setProperties(delegate: AddExpenseDelegate, categoryToSuggest: String?) {
        guard self.editExpenseDelegate == nil else {
            fatalError("AddOrEditTableViewController can be used for either editing an existing expense, or creating a new expense, not both.")
        }
        self.addExpenseDelegate = delegate
        if categoryToSuggest != nil {
            self.category = categoryToSuggest
        }
        self.navigationItem.title = "New Expense"
        self.date = Date()
    }
    
    func setProperties(delegate: EditExpenseDelegate, transactionToEdit: Transaction) {
        guard self.addExpenseDelegate == nil else {
            fatalError("AddOrEditTableViewController can be used for either editing an existing expense, or creating a new expense, not both.")
        }
        self.editExpenseDelegate = delegate
        self.transactionToEdit = transactionToEdit
        self.navigationItem.title = "Edit Expense"
        self.amount = transactionToEdit.amount
        self.category = transactionToEdit.category
        self.transactionDescription = transactionToEdit.descript
        self.date = transactionToEdit.date
    }
    
    func updateSaveButtonState() {
        if self.transactionToEdit != nil {
            if !self.categoryIsValid {
                self.saveButton.isEnabled = false
            } else if !self.amountIsValid {
                self.saveButton.isEnabled = false
            } else if !self.transactionDescriptionIsValid {
                self.saveButton.isEnabled = false
            } else if self.category != self.transactionToEdit?.category {
                self.saveButton.isEnabled = true
            } else if self.amount != self.transactionToEdit?.amount {
                self.saveButton.isEnabled = true
            } else if self.transactionDescription != self.transactionToEdit?.descript {
                self.saveButton.isEnabled = true
            } else if self.date != self.transactionToEdit?.date {
                self.saveButton.isEnabled = true
            } else {
                self.saveButton.isEnabled = false
            }
        } else {
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: Select Category Delegate
    
    func didFinishSelecting(_ selectCategoryController: SelectCategoryTableViewController, category: String?) {
        if let newCategory = category, newCategory != self.category {
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
            selectCategoryTableViewController.setProperties(delegate: self)
        }
    }
    
    // MARK: Actions
    
    @objc func handleDatePickerValueChange() {
        self.date = self.datePickerTableViewCell?.datePicker.date
    }
    
    func handleTableDateTableViewCellTap() {
        self.datePickerVisible = !self.datePickerVisible
    }
    
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.editExpenseDelegate?.didFinishEditing(self, expense: nil)
        self.addExpenseDelegate?.didFinishAdding(self, expense: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if self.transactionToEdit != nil {
            self.user.editTransaction(self.transactionToEdit!, date: self.date, descript: self.transactionDescription!, amount: self.amount!, category: self.category!)
            self.editExpenseDelegate?.didFinishEditing(self, expense: self.transactionToEdit!)
        } else {
            let newTransaction = self.user.addTransaction(date: self.date, descript: self.transactionDescription!, amount: self.amount!, category: self.category!)
            self.addExpenseDelegate?.didFinishAdding(self, expense: newTransaction)
        }
        self.saveData()
    }
}



