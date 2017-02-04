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
            self.ref.child("users").child(user!.uid).setValue([
                "email": user?.email,
                "name": user?.displayName,
                "avatarUrl": user?.photoURL?.absoluteString
            ])
            
            self.gotoJoinRoom()
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try? FIRAuth.auth()?.signOut()
    }
}
