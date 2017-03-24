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
import NVActivityIndicatorView

class SplashViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup loading
        let center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        let indicatorSize: CGFloat = 60
        
        let loadingIndicator = NVActivityIndicatorView(
            frame: CGRect(x: center.x - indicatorSize / 2, y: center.y - indicatorSize / 2, width: indicatorSize, height: indicatorSize),
            type: .ballClipRotatePulse,
            color: UIColor.white,
            padding: 0
        )
        loadingIndicator.startAnimating()
        
        self.view.addSubview(loadingIndicator)
        
        if let user = FIRAuth.auth()?.currentUser {
            let ref = FIRDatabase.database().reference()
            
            // Get user
            print("GETTING USER")
            ref.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                let userData = snapshot.value as? NSDictionary
                
                let user = User(id: user.uid, name: userData?["name"] as? String, email: userData?["email"] as? String, avatarUrl: userData?["avatarUrl"] as? String)
                self.appDelegate.localUser = user
                
                
                if let group = userData?["group"] as? String {
                    let group = Group(id: group, joinKey: "", members: [])
                    self.appDelegate.localGroup = group
                    
                    self.fadeOutAnimation {
                        self.gotoRoom()
                    }
                } else {
                    self.fadeOutAnimation {
                        self.gotoEntry()
                    }
                }
                
                // TODO: Validate group
            })
            
        } else {
            self.fadeOutAnimation {
                self.gotoEntry()
            }
        }
    }
    
    func fadeOutAnimation(complete: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.white
        }) { (done) in
            complete()
        }
    }

    func gotoEntry() {
        self.performSegue(withIdentifier: "EntryViewController", sender: self)
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
}
