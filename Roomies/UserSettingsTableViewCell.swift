//
//  UserSettingsTableViewCell.swift
//  Roomies
//
//  Created by Mary Huerta on 4/28/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class UserSettingsTableViewCell: UITableViewCell {

    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
