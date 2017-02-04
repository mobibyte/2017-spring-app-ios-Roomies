//
//  JoinRoomViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 1/27/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class JoinRoomViewController: UIViewController {

    @IBOutlet weak var roomCodeTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    
    @IBAction func joinRoomPressed(_ sender: UIButton) {
    }
    
    @IBAction func createRoomPressed(_ sender: UIButton) {
        createRoom()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
    }
    
    func createRoom() {
        let key = ref.child("groups").childByAutoId().key
        let userId = FIRAuth.auth()?.currentUser?.uid
        
        let group = [
            "creator": userId
        ]
        
        // Add group and update user
        let updates: [String:Any] = [
            "/groups/\(key)": group,
            "/users/\(userId!)/group": key
        ]

        ref.updateChildValues(updates) { (error, dataGroup) in
            self.gotoRoom()
        }
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
}
