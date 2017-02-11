//
//  textViewTableViewCell.swift
//  FoodPin
//
//  Created by Mary Huerta on 10/31/16.
//  Copyright © 2016 Mary Huerta. All rights reserved.
//

import Foundation
import UIKit

class TextViewTableViewCell: UITableViewCell {
    
    @IBOutlet var expenseTitle: UITextField!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected( _ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
