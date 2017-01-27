//
//  TaskTableViewCell.swift
//  Roomies
//
//  Created by Mary Huerta on 1/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    //@IBOutlet var taskOwner: UILabel!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskDueDate: UILabel!
    @IBOutlet var taskOwners: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
