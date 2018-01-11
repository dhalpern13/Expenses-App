//
//  AmountTableViewCell.swift
//  Expenses App
//
//  Created by Christopher Bantle on 2018-01-10.
//  Copyright © 2018 Christopher Bantle and Daniel Halpern. All rights reserved.
//

import UIKit

class AmountTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var displayFullAmountOnLabel = true
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTextEntry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
