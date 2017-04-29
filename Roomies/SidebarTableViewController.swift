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
//    print("This is a local user")

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = localUser {
            nameLabel.text = user.name
            
        }
        
        Alamofire.request((localUser?.avatarUrl)!).responseImage { response in
            print("got the response")
            print(response.result.value)
            
            if let image = response.result.value {
                self.sidebarAvatar.image = image
            }
        }
        print("The local user is " + (localUser?.avatarUrl)!)
        
//        sidebarAvatar.image =
    }

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var sidebarAvatar: UIImageView!
    
}
