//
//  SelectCategoryTableViewController.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-11.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

protocol SelectCategoryDelegate {
    func didFinishSelecting(_ selectCategoryController: SelectCategoryTableViewController, category: String?)
}

class SelectCategoryTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var delegate: SelectCategoryDelegate?
    
    var category: String?

    // MARK: UITableView Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set category
        self.delegate?.didFinishSelecting(self, category: self.category)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // set value of category
        self.delegate?.didFinishSelecting(self, category: self.category)
    }
    
    // MARK: Action
    
    @IBAction func handleAddCategory(_ sender: Any) {
        let alertController = UIAlertController(title: "Add new category.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let addCategoryAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
            // add category to manager, and load the category at the given row
        })
        alertController.addAction(addCategoryAction)
        
        alertController.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "Category"
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.delegate?.didFinishSelecting(self, category: self.category)
    }
}
