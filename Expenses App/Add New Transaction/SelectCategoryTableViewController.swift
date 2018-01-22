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
    
    private var addCategoryAlertController: UIAlertController?
    
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
        let alertController = UIAlertController(title: "New Category.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        self.addCategoryAlertController = alertController
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let addCategoryAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
            if let newCategory = alertController.textFields?[0].text {
                self.user.addCategory(newCategory)
                self.delegate?.didFinishSelecting(self, category: newCategory)
            }
        })
        self.addCategoryAlertActionSaveAction = addCategoryAction
        addCategoryAction.isEnabled = false
        alertController.addAction(addCategoryAction)
        
        alertController.addTextField(configurationHandler: { (textfield) in
            textfield.addTarget(self, action: #selector(self.handleTextFieldChange(_:)), for: .editingChanged)
            textfield.addTarget(self, action: #selector(self.handleKeyboardDoneButtonPressWhenAddingNewCategory(_:)), for: .editingDidEndOnExit)
            textfield.clearButtonMode = .whileEditing
            textfield.returnKeyType = .done
            textfield.enablesReturnKeyAutomatically = true
            textfield.autocapitalizationType = .words
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
    
    @objc func handleKeyboardDoneButtonPressWhenAddingNewCategory(_ sender: UITextField) {
        self.addCategoryAlertController?.dismiss(animated: true, completion: nil)
        self.delegate?.didFinishSelecting(self, category: sender.text)
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.delegate?.didFinishSelecting(self, category: nil)
    }
}
