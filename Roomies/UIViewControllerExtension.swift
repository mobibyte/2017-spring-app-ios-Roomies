//
//  UIViewControllerExtension.swift
//  Roomies
//
//  Created by Cameron Moreau on 2/11/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

extension UIViewController {

    func showBasicAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
