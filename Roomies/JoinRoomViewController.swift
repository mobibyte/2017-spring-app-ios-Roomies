//
//  JoinRoomViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 1/27/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class JoinRoomViewController: UIViewController {

    @IBOutlet weak var roomCodeTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    
    @IBAction func joinRoomPressed(_ sender: UIButton) {
        attemptJoinRoom(key: roomCodeTextField.text)
    }
    
    @IBAction func createRoomPressed(_ sender: UIButton) {
        createRoom()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
    
    // MARK: - Join room
    func attemptJoinRoom(key: String?) {
        if let key = key, key.characters.count > 0 {
            ref.child("groupKeys/\(key)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let groupId = snapshot.value as? String {
                    self.joinRoom(groupId: groupId)
                } else {
                    self.showBasicAlert(title: "Uh oh", message: "Invalid room key")
                }
            })
        } else {
            self.showBasicAlert(title: "Uh oh", message: "A room key is required")
        }
    }
    
    func joinRoom(groupId: String) {
        let userId = FIRAuth.auth()?.currentUser?.uid
        
        let updates: [String:Any] = [
            "/users/\(userId!)/group": groupId,
            "/groups/\(groupId)/members/\(userId!)": true
        ]
        
        
        ref.updateChildValues(updates) { (error, dataGroup) in
            self.gotoRoom()
        }
    }
    
    
    // MARK: - Create room
    func createRoom() {
        let key = ref.child("groups").childByAutoId().key
        let userId = FIRAuth.auth()?.currentUser?.uid
        let groupKey = self.generateRoomKey(length: 8)
        
        let members = [
            "\(userId!)": true
        ]
        
        let group: [String:Any] = [
            "creator": userId!,
            "key": groupKey,
            "members": members
        ]
        
        // Add group and update user
        let updates: [String:Any] = [
            "/groups/\(key)": group,                        // Create the group
            "/users/\(userId!)/group": key,                 // Assign group to user
            "/groupKeys/\(groupKey)": key                   // Create a join key
        ]

        ref.updateChildValues(updates) { (error, dataGroup) in
            self.gotoRoom()
        }
    }
    
    func generateRoomKey(length: Int) -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
