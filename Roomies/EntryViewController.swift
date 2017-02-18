//
//  EntryViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 12/2/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup db
        ref = FIRDatabase.database().reference()
        
        // Facebook login
        loginButton.readPermissions = [
            "public_profile", "email"
        ]
        loginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Launch next page if logged int
        if FIRAuth.auth()?.currentUser != nil {
            self.gotoJoinRoom()
        }
    }
    
    func gotoJoinRoom() {
        self.performSegue(withIdentifier: "JoinRoomSegue", sender: self)
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
    
    // Already apart of a group, join that one or
    func joinOrLeave(userId: String, groupId: String) {
        let alert = UIAlertController(
            title: "Decisions!",
            message: "It looks like you are already apart of a group. Would you like to join that group or leave and join another?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Leave Group", style: .destructive, handler: { (action) in
            // Leave group
            let updates: [String:Any?] = [
                "users/\(userId)/group": nil,
                "groups/\(groupId)/members/\(userId)": nil
            ]
            
            // Update and goto join
            self.ref.updateChildValues(updates) { error, data in
                self.gotoJoinRoom()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Join Existing", style: .default, handler: { (action) in
            self.gotoRoom()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let streetCreds = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: streetCreds, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            // Update info on db
            let updates: [String:Any?] = [
                "email": user?.email,
                "name": user?.displayName,
                "avatarUrl": user?.photoURL?.absoluteString
            ]
            
            self.ref.child("users/\(user!.uid)").updateChildValues(updates) { (error, dataGroup) in
                
                // Check if user is already apart of a group
                self.ref.child("users/\(user!.uid)/group").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let groupId = snapshot.value as? String {
                        self.joinOrLeave(userId: user!.uid, groupId: groupId)
                    } else {
                        self.gotoJoinRoom()
                    }
                })
                
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try? FIRAuth.auth()?.signOut()
    }
}
