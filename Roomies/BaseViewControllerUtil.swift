//
//  BaseViewControllerUtil.swift
//  Roomies
//
//  Created by Cameron Moreau on 2/10/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import SWRevealViewController

class BaseViewControllerUtil {
    
    static func setup(viewController vc: UIViewController) {
        if vc.revealViewController() != nil {
            vc.view.addGestureRecognizer(vc.revealViewController().panGestureRecognizer())
            
            // Add menu button automatically
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Menu",
                style: .plain,
                target: vc.revealViewController(),
                action: #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void)
            )
        }
    }
    
}
