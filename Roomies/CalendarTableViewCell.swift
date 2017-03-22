//
//  CalendarTableViewCell.swift
//  Roomies
//
//  Created by Matthew Mcleod on 11/11/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDatetime: UILabel!
    
    @IBOutlet weak var eventEndtime: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
