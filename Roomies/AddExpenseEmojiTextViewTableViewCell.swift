//
//  AddExpenseEmojiTextViewTableViewCell.swift
//  Roomies
//
//  Created by Mary Huerta on 2/17/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import UIKit

class EmojiTextViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet var emojiTextView: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
