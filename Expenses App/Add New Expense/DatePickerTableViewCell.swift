//
//  DatePickerTableViewCell.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-09.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
