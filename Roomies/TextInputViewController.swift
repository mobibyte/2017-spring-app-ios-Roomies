//
//  TextInputViewController.swift
//  FoodPin
//
//  Created by Mary Huerta on 11/2/16.
//  Copyright © 2016 Mary Huerta. All rights reserved.
//

import Foundation

import UIKit

class TextInputViewController: UIViewController{
    
    
    @IBOutlet weak var amountTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController : AddExpenseTableViewController = segue.destination as! AddExpenseTableViewController
        
        DestViewController.amountText = amountTextField.text!
        
        
    }
    
    
    override func viewDidLoad() {
        
    }
    
    
    
}
