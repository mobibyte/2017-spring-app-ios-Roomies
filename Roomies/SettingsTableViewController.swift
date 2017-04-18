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
class SettingsTableViewController: UITableViewController {
    
    let ref = FIRDatabase.database().reference()
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    

    
    var userNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user IDs for choosing roomates
        ref.child("groups/\(localGroup.id)/members").observe(.childAdded, with: { (snapshot) in
            
            self.userNames.append(snapshot.key)
            
            self.tableView.reloadData()
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            let cellIdentifier = "LogoutCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        } else {
            let cellIdentifier = "userCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel!.text = localGroup.members[userNames[indexPath.row]]?.name
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
