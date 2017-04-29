//
//  SettingsTableViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 2/10/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase
import Alamofire
class SettingsTableViewController: UITableViewController {
    
    var localAdmin = ""
    let ref = FIRDatabase.database().reference()
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    var userName = ""
    var userNames = [String]()
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user IDs for choosing roomates
        ref.child("groups/\(localGroup.id)/members").observe(.childAdded, with: { (snapshot) in
            
            self.userNames.append(snapshot.key)
            
            self.tableView.reloadData()
        })
        ref.child("groups/\(localGroup.id)").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                self.localAdmin = (value["creator"] as! String)
                print(self.localAdmin)
                print("CHECK THIS OUT IT")
            }
           
        })
        BaseViewControllerUtil.setup(viewController: self)
        
    
        

    }
    //Number of Sections and Rows
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0:
            return 1
        case 1:
            return userNames.count
        default:
            return 0
        }

    }

    func logoutWarning() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out? Your roommates will miss you", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Logout"
        case 1:
            return "Roomies"
        default:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            let cellIdentifier = "LogoutCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        } else {
            let cellIdentifier = "userCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserSettingsTableViewCell
            
            
            userName = (localGroup.members[userNames[indexPath.row]]?.name)!
            
            cell.userName.text = userName
            
            
            Alamofire.request((localGroup.members[userNames[indexPath.row]]?.avatarUrl)!).responseImage { response in
                print("got the response")
                print(response.result.value as Any)
                
                if let image = response.result.value {
                    cell.userImage.image = image
                    cell.userImage.layer.cornerRadius = 14.0
                    cell.userImage.clipsToBounds = true
                }
            }
            return cell
        }
    }
    

    
    
    func logout() {
        // Logout firebase + facebook
        try! FIRAuth.auth()?.signOut()
        FBSDKLoginManager().logOut()
        
        // Change pages
        self.performSegue(withIdentifier: "LogoutSegue", sender: self)
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0{
            logoutWarning()
        }
    }
}
