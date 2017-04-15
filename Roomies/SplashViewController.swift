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
import PromiseKit

enum LoginError: Error {
    case notLoggedIn
    case notInGroup
}

class SplashViewController: UIViewController {
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ref: FIRDatabaseReference!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.ref = FIRDatabase.database().reference()
        
        // Setup loading
        let center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        let indicatorSize: CGFloat = 60
        
        let loadingIndicator = NVActivityIndicatorView(
            frame: CGRect(
                x: center.x - indicatorSize / 2,
                y: center.y - indicatorSize / 2,
                width: indicatorSize,
                height: indicatorSize
            ),
            type: .ballClipRotatePulse,
            color: UIColor.white,
            padding: 0
        )
        loadingIndicator.startAnimating()
        
        self.view.addSubview(loadingIndicator)
        
        var groupId: String!
        let currentUser = FIRAuth.auth()?.currentUser
        
        self.fetchUserData(currentUser: currentUser).then { userData -> Promise<NSDictionary> in
            // Create user from data and store global
            let user = User(
                id: currentUser!.uid,
                name: userData["name"] as? String,
                email: userData["email"] as? String,
                avatarUrl: userData["avatarUrl"] as? String
            )
            self.appDelegate.localUser = user
            
            groupId = userData["group"] as? String
            
            // Get group data
            return self.fetchGroupData(groupId: groupId)
            
        }.then { groupData -> Promise<[String:NSDictionary]> in
            // Create group from data and store global
            let group = Group(id: groupId, joinKey: "", members: [:])
            self.appDelegate.localGroup = group
            
            // TODO: Filter out those with False
            let members = (groupData["members"] as! NSDictionary).allKeys as! [String]
            return self.fetchGroupMembers(members: members)
            
        }.then { members -> Void in
            // Load up local group members by data
            for m in members {
                let member = User(
                    id: m.key,
                    name: m.value["name"] as? String,
                    email: m.value["email"] as? String,
                    avatarUrl: m.value["avatarUrl"] as? String
                )
                self.appDelegate.localGroup?.members[m.key] = member
            }
            
            // AAANNNDDD action..
            self.fadeOutAnimation {
                self.gotoRoom()
            }
        }.catch { error in
            print("WAS AN EROR")
            self.fadeOutAnimation {
                self.gotoEntry()
            }
        }
    }
    
    // MARK: Promise data calls
    func fetchUserData(currentUser: FIRUser?) -> Promise<NSDictionary> {
        return Promise { resolve, reject in
            guard let currentUser = currentUser else { return reject(LoginError.notLoggedIn) }
            
            ref.child("users/\(currentUser.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                resolve(snapshot.value as! NSDictionary)
            })
        }
    }
    
    func fetchGroupData(groupId: String?) -> Promise<NSDictionary> {
        return Promise { resolve, reject in
            guard let groupId = groupId else { return reject(LoginError.notInGroup) }
            
            ref.child("groups/\(groupId)").observeSingleEvent(of: .value, with: { (snapshot) in
                resolve(snapshot.value as! NSDictionary)
            })
        }
    }
    
    func fetchGroupMembers(members: [String]) -> Promise<[String:NSDictionary]> {
        return Promise { resolve, reject in
            var data = [String:NSDictionary]()
            
            if members.count == 0 {
                resolve([:])
            }
            
            for user in members {
                ref.child("users/\(user)").observeSingleEvent(of: .value, with: { (snapshot) in
                    data[user] = snapshot.value as! NSDictionary
                    
                    // All data is finished
                    if(data.count == members.count) {
                        resolve(data)
                    }
                })
            }
        }
    }
    
    // MARK: UI Stuff
    func fadeOutAnimation(complete: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.white
        }) { (done) in
            complete()
        }
    }

    // MARK: Navigation
    func gotoEntry() {
        self.performSegue(withIdentifier: "EntryViewController", sender: self)
    }
    
    func gotoRoom() {
        self.performSegue(withIdentifier: "OpenRoomSegue", sender: self)
    }
}
