//
//  SelectCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-11.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol SelectCategoryDelegate: NSObjectProtocol {
    func didFinishSelecting(_ selectCategoryController: SelectCategoryTableViewController, category: String?)
}

class SelectCategoryTableViewController: UITableViewController {
    
    // MARK: Properties
    
    weak private var delegate: SelectCategoryDelegate?
    
    private var addCategoryAlertActionSaveAction: UIAlertAction?
    
    private var categories: [String]!
    
    // MARK: Setup
    
    func setProperties(delegate: SelectCategoryDelegate) {
        self.delegate = delegate
        self.categories = self.user.categories
    }

    // MARK: UITableView Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath)
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = self.categories[indexPath.row]
        self.delegate?.didFinishSelecting(self, category: selectedCategory)
    }
    
    // MARK: Action
    
    @IBAction func handleAddCategory(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter a new category.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let addCategoryAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
            if let newCategory = alertController.textFields?[0].text {
                let newRow = self.categories.count
                let indexPath = IndexPath(row: newRow, section: 0)
                self.user.addCategory(newCategory)
                self.categories?.append(newCategory)
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
        })
        self.addCategoryAlertActionSaveAction = addCategoryAction
        addCategoryAction.isEnabled = false
        alertController.addAction(addCategoryAction)
        
        alertController.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "Category"
            textfield.addTarget(self, action: #selector(self.handleTextFieldChange(_:)), for: .editingChanged)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTextFieldChange(_ sender: UITextField) {
        if sender.text != nil && !sender.text!.isEmpty {
            self.addCategoryAlertActionSaveAction?.isEnabled = true
        } else {
            self.addCategoryAlertActionSaveAction?.isEnabled = false
        }
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.delegate?.didFinishSelecting(self, category: nil)
    }
}
