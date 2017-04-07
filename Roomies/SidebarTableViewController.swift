//
//  SidebarTableViewController.swift
//  Roomies
//
//  Created by Kyrell Dixon on 3/24/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SidebarTableViewController: UITableViewController {
    
    let localUser = (UIApplication.shared.delegate as! AppDelegate).localUser

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = localUser {
            nameLabel.text = user.name
        }
        
        Alamofire.request("http://www.dogwood.church/wp-content/uploads/2014/03/generic-male-avatar.png").responseImage { response in
            print("got the response")
            print(response.result.value)
            
            if let image = response.result.value {
                self.sidebarAvatar.image = image
            }
        }
        
//        sidebarAvatar.image =
    }

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var sidebarAvatar: UIImageView!
    
}
