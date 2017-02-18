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

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        BaseViewControllerUtil.setup(viewController: self)
    }
    
    
    func logoutWarning() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out? Your roommates will miss you", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
        
        if indexPath.section == 0 {
            logoutWarning()
        }
    }
}
