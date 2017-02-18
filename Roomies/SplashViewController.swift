//
//  SplashViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 1/27/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = FIRAuth.auth()?.currentUser {
            let ref = FIRDatabase.database().reference()
            
            // Get user
            print("GETTING USER")
            ref.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                let userData = snapshot.value as? NSDictionary
                
                if userData?["group"] != nil {
                    self.gotoRoom()
                } else {
                    self.gotoEntry()
                }
                
                // TODO: Validate group
            })
            
        } else {
            self.gotoEntry()
        }
    }

    func gotoEntry() {
        self.performSegue(withIdentifier: "EntryViewController", sender: self)
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
}
