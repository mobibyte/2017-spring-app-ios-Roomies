//
//  ExpenseTableViewCell.swift
//  Roomies
//
//  Created by Mary Huerta on 12/29/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet var expenseAmount: UILabel!
    @IBOutlet var expenseTitle: UILabel!
    @IBOutlet var expenseForUser: UILabel!
    @IBOutlet var expenseCategory: UILabel!
    @IBOutlet var emojiImage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
