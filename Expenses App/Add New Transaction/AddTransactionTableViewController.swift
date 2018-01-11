//
//  AddOrEditTransactionTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-10.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class AddOrEditTransactionTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Properties
    
    var transaction: DemoTransaction?
    
    var friendToSuggest: String?
    
    var categoryToSuggest: String?
    
    var newExpenseMode = true {
        didSet {
            self.tableView.reloadSections([1, 2, 3, 4, 5], with: .automatic)
            self.updateSaveButtonState()
        }
    }
    
    // MARK: Properties - For New Transaction
    
    var date: Date! {
        didSet {
            self.dateTableViewCell?.detailTextLabel?.text = self.dateFormatter.string(from: self.date)
        }
    }
    
    // MARK: Properties - For New Transaction, Expense-Specific
    
    var expenseDescriptionValid = false {
        didSet {
           self.updateSaveButtonState()
        }
    }
    
    var expenseDescription: String? {
        didSet {
            self.chooseDescriptionTableViewCell?.detailTextLabel?.text = self.expenseDescription
            self.expenseDescriptionValid = self.expenseDescription != nil
        }
    }
    
    var categoriesAndAmountsValid = false {
        didSet {
            self.updateSaveButtonState()
        }
    }
    
    var categories: [String] {
        get {
            return categoryToAmount.keys.sorted()
        }
    }
    
    var categoryToAmount = [String: Decimal]() {
        didSet {
            self.categoriesAndAmountsValid = self.areCategoriesAndAmountsValid()
        }
    }
    
    var friends: [String] {
        get {
            return friendToAmount.keys.sorted()
        }
    }
    
    var friendToAmount = [String: Decimal]() {
        didSet {
            self.categoriesAndAmountsValid = self.areCategoriesAndAmountsValid()
        }
    }
    
    func areCategoriesAndAmountsValid() -> Bool {
        if self.friendToAmount.count == 0 && self.categoryToAmount.count == 0 {
            return false
        } else {
            if friendToAmount.count > 1 {
                for friend in friendToAmount.keys {
                    if friendToAmount[friend]! <= 0 {
                        return false
                    }
                }
            }
            
            if categoryToAmount.count > 1 {
                for category in categoryToAmount.keys {
                    if categoryToAmount[category]! <= 0 {
                        return false
                    }
                }
            }
            
            return true
        }
    }
    
    // MARK: Properties - For New Transaction, Payment-Specific
    
    var otherPartyPaid = false
    
    var otherPartyValid = false {
        didSet {
            self.updateSaveButtonState()
        }
    }
    
    var paymentOtherParty: String? {
        didSet {
            self.otherPartyForPaymentTableViewCell?.detailTextLabel?.text = self.paymentOtherParty
            self.otherPartyValid = self.paymentOtherParty != nil
        }
    }
    
    var paymentAmountValid = false {
        didSet {
            self.updateSaveButtonState()
        }
    }
    
    var paymentAmount: Decimal? {
        didSet {
            self.paymentAmountValid = self.paymentAmount != nil && self.paymentAmount! > 0
        }
    }
    
    
    // MARK: Properties - UI Items
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dateTableViewCell: UITableViewCell?
    var datePickerVisible = false {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    var datePickerTableViewCell: DatePickerTableViewCell?
    var paymentExpenseSegmentControllerTableViewCell: PaymentExpenseSegmentControllerTableViewCell?
    var amountTableViewCell: AmountTableViewCell?
    var addFriendTableViewCell: UITableViewCell?
    
    // MARK: Properties - UI Items - Specific to Payment
    
    var otherPartyForPaymentTableViewCell: UITableViewCell?
    var whoRecievedPaymentTableViewCell: WhoRecievedPaymentSegmentControllerTableViewCell?
    
    // MARK: Properties - UI Items - Specific to Expense
    
    var chooseDescriptionTableViewCell: UITableViewCell?
    
    func updateSaveButtonState() {
        if newExpenseMode{
            if !self.expenseDescriptionValid {
                self.saveButton.isEnabled = false
            } else if !self.categoriesAndAmountsValid {
                self.saveButton.isEnabled = false
            } else {
                self.saveButton.isEnabled = true
            }
        } else {
            if !self.otherPartyValid {
                self.saveButton.isEnabled = false
            } else if !self.paymentAmountValid {
                self.saveButton.isEnabled = false
            } else {
                self.saveButton.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date = Date()
        
        self.friendToAmount = ["John Smith": Decimal(120.60)]
        
        self.categoryToAmount = ["Grocery": Decimal(56.79)]
        
        if let friend = self.friendToSuggest {
            self.friendToAmount[friend] = Decimal(0)
        }
        
        if let category = self.categoryToSuggest {
            self.categoryToAmount[category] = Decimal(0)
        }
        
        self.saveButton.isEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && self.datePickerVisible {
            return 2
        } else if section == 3 && self.newExpenseMode {
            return self.categories.count + 1
        } else if section == 4 && self.newExpenseMode {
            return self.friends.count + 1
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentExpenseSegmentControllerTableViewCell", for: indexPath) as! PaymentExpenseSegmentControllerTableViewCell
            self.paymentExpenseSegmentControllerTableViewCell = cell
            self.paymentExpenseSegmentControllerTableViewCell?.paymentExpenseSegmentController.addTarget(self, action: #selector(handleExpensePaymentSegmentControllerValueChange), for: UIControlEvents.valueChanged)
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateTableViewCell", for: indexPath)
                self.dateTableViewCell = cell
                self.dateTableViewCell?.detailTextLabel?.text = self.dateFormatter.string(from: self.date)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
                self.datePickerTableViewCell = cell
                self.datePickerTableViewCell?.datePicker.setDate(self.date, animated: false)
                self.datePickerTableViewCell?.datePicker.addTarget(self, action: #selector(handleExpensePaymentSegmentControllerValueChange), for: .valueChanged)
                return cell
            }
        } else if indexPath.section == 2 {
            if self.newExpenseMode {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chooseDescriptionTableViewCell", for: indexPath)
                self.chooseDescriptionTableViewCell = cell
                if self.expenseDescription != nil {
                    self.chooseDescriptionTableViewCell?.detailTextLabel?.text = self.expenseDescription
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "whoRecievedPaymentTableViewCell", for: indexPath) as! WhoRecievedPaymentSegmentControllerTableViewCell
                self.whoRecievedPaymentTableViewCell = cell
                if self.otherPartyPaid {
                    self.whoRecievedPaymentTableViewCell?.whoPaidSegmentController.selectedSegmentIndex = 1
                } else {
                    self.whoRecievedPaymentTableViewCell?.whoPaidSegmentController.selectedSegmentIndex = 0
                }
                return cell
            }
        } else if indexPath.section == 3 {
            if self.newExpenseMode {
                if indexPath.row == self.categories.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addCategoryTableViewCell", for: indexPath)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryOrFriendTableViewCell", for: indexPath) as! CategoryOrFriendTableViewCell
                    cell.categoryOrFriendLabel.text = self.categories[indexPath.row]
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "otherPartyForPaymentTableViewCell", for: indexPath)
                self.otherPartyForPaymentTableViewCell = cell
                if self.paymentOtherParty != nil {
                    self.otherPartyForPaymentTableViewCell?.detailTextLabel?.text = self.paymentOtherParty
                }
                return cell
            }
        } else {
            if self.newExpenseMode {
                if indexPath.row == self.friends.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendTableViewCell", for: indexPath)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryOrFriendTableViewCell", for: indexPath) as! CategoryOrFriendTableViewCell
                    cell.categoryOrFriendLabel.text = self.friends[indexPath.row]
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "amountTableViewCell", for: indexPath) as! AmountTableViewCell
                self.amountTableViewCell = cell
                self.amountTableViewCell?.amountTextEntry.delegate = self
                return cell
            }
        }
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            self.handleTableDateTableViewCellTap()
        }
    }
    
    // MARK: Actions
    
    @objc func handleExpensePaymentSegmentControllerValueChange() {
        tableView.reloadSections([1, 2, 3, 4, 5], with: .automatic)
    }
    
    @objc func handleDatePickerValueChange() {
        self.date = self.datePickerTableViewCell?.datePicker.date
    }
    
    func handleTableDateTableViewCellTap() {
        self.datePickerVisible = !self.datePickerVisible
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
