//
//  RestaruantTableViewController.swift
//  FoodPin
//
//  Created by Mary Huerta on 10/24/16.
//  Copyright © 2016 Mary Huerta. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
    var allCellsText = ""
    var emojiText = ""
    var expenseType = ""
    @IBOutlet var amount: UITextField!
    
    let addExpense = Expense()
    var expense:ExpenseMO!
    var arrayOfNames : [String] = [String]()
    var rowBeingEdited : Int? = nil
    var selectedUser:String? = nil
    var selectedUserIndex:Int? = nil
    
    var amountText = String()
    
    var selectedIndexPath : IndexPath?
    var pickerExpenseTypeArray = [ "Rent", "Bills", "Entertainment", "Food", "Other" ]
    var userNames = ["Bruce", "Wade", "Logan"]
    var userImages = ["User1", "User2", "User3"]
    
    override func viewDidLoad() {
        
        
    }
    
    
    // MARK: - Picker View
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerExpenseTypeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerExpenseTypeArray.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0:
            return userNames.count
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            
            
            let cellIdentifier = "UserTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
            
            // Configure the cell...
            cell.nameLabel.text = userNames[indexPath.row]
            cell.thumbnailImageView.image = UIImage(named: userImages[indexPath.row])
            cell.accessoryType = indexPath.row == selectedUserIndex ?  .checkmark : .none
            
            return cell
            
        }  else {
            
            if indexPath.row == 0 {
                
                let cellIdentifier = "textViewTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextViewTableViewCell
                cell.expenseTitle.text = ""
                cell.expenseTitle.delegate = self
                
                return cell
                
            } else if (indexPath.row == 1) {
                let cellIdentifer = "emojiTextViewTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! EmojiTextViewTableViewCell
                cell.emojiTextView.text = ""
                
                
                return cell
            }else {
                let cellIdentifier = "pickerViewTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PickerViewTableViewCell
                
                cell.categoryPicker.showsSelectionIndicator = true
                cell.categoryPicker.delegate = self
                cell.categoryPicker.dataSource = self
                
                
                
                return cell
            }
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { //Toggle Selected User
            
            //Other row is selected - need to deselect it
            if let index = selectedUserIndex {
                let cell = tableView.cellForRow(at: NSIndexPath(row: index, section: 0) as IndexPath)
                cell?.accessoryType = .none
            }
            
            selectedUserIndex = indexPath.row
            selectedUser = userNames[indexPath.row]
            
            //update the checkmark for the current row
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            
            
            let previousIndexPath = selectedIndexPath
            if indexPath == selectedIndexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
            
            var indexPaths : Array<IndexPath> = []
            
            if let previous = previousIndexPath {
                indexPaths += [previous]
            }
            
            if let current = selectedIndexPath {
                indexPaths += [current]
            }
            
            if indexPaths.count > 0 {
                tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
            }
            
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            let indexPath = IndexPath(row: numberOfRows-2 , section: numberOfSections-1)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
            
            
        }
        else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            (cell as! PickerViewTableViewCell).watchFrameChanges()
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            (cell as! PickerViewTableViewCell).ignoreFrameChanges()
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Choose a roommate"
        case 1:
            return "Other Info"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            if indexPath == selectedIndexPath {
                return PickerViewTableViewCell.expandedHeight
            } else {
                return PickerViewTableViewCell.defaultHeight
            }
        }
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView.rowHeight
    }
    
    
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        
        allCellsText = sender.text!
        
    }
    
    @IBAction func emojiFieldDidChangeEditing(_ sender: UITextField) {
        
        emojiText = sender.text!
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expenseType = pickerExpenseTypeArray[row]
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "doneExpense" {
            if amount.text == "0" {
                let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
                return false
                
            }
        }
        
        
        
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneExpense" {
            
            if amount.text == "0" {
                let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
            
            print("Amount: \(amount.text)")
            print("User: \(selectedUser)")
            print("Type: \(expenseType)")
            print("Title: \(allCellsText)")
            print("Emoji: \(emojiText)")
            //            print("Emoji: \(emojiTextView.text)")
            addExpense.amount = amount.text
            addExpense.username = selectedUser
            addExpense.type = expenseType
            addExpense.title = allCellsText
            addExpense.emoji = emojiText
            
            print("Saving data to context ...")
            
        }
        
    }
    
    
}


