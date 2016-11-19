//
//  RestaruantTableViewController.swift
//  FoodPin
//
//  Created by Mary Huerta on 10/24/16.
//  Copyright © 2016 Mary Huerta. All rights reserved.
//

import UIKit


protocol AddExpenseDelegate {
    func addExpense( expense: Expense)
    func cancelExpense()
    
}


class AddExpenseTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    @IBOutlet weak var amount: UILabel!
    var amountText = String()
    
    var delegate: AddExpenseDelegate
    
    var selectedIndexPath : IndexPath?
    
    var array = [ "Rent", "Bills", "Entertainment", "Food", "Other" , ]
    
    
    var userNames = ["Bruce", "Wade", "Logan"]
    var userImages = ["wafflewolf.jpg", "homei.jpg", "teakha.jpg"]
    var UserIsVotedfor = Array(repeating: false, count: 4)
    
    
<<<<<<< HEAD
    
    
=======
>>>>>>> 237f53b1e2075a5e6a02c63ed35d69e81ef2a07e
    
    
    //Text Input for label
    override func viewDidLoad() {
        //amount.text = "$" + amountText
    }
    
    
    // MARK: - Picker View
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
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
            return 2
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RestaurantTableViewCell")
            let cellIdentifier = "UserTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
            
            // Configure the cell...
            cell.nameLabel.text = userNames[indexPath.row]
            cell.thumbnailImageView.image = UIImage(named: userImages[indexPath.row])
            
            //Put check mark in if restaurant has been voted for
            if UserIsVotedfor[indexPath.row]{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
            
        }  else {
            
            if indexPath.row == 0 {
                let cellIdentifier = "textViewTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextViewTableViewCell
                return cell
            } else {
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
        if indexPath.section == 0 {
            
            // Create an option menu as an action sheet
            let optionMenu = UIAlertController(title: nil, message: "Who has to pay?", preferredStyle: .actionSheet)
            
            
            
            
            //***Add to vote ***
            
            
            
            let voteActionHandler = { (action:UIAlertAction!) -> Void in  // <- in indicates the start of the closure body
                //Closure Body
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .checkmark
                
                self.UserIsVotedfor[indexPath.row] = self.UserIsVotedfor[indexPath.row] ? false : true
                cell?.accessoryType = self.UserIsVotedfor[indexPath.row] ? .checkmark : .none
            }
            
            
            
            // Add actions to the main menu
            
            
            if (!UserIsVotedfor[indexPath.row]){
                let voteAction = UIAlertAction(title: userNames[indexPath.row] + " has to pay", style: .default, handler: voteActionHandler)
                optionMenu.addAction(voteAction)
            } else {
                let voteAction = UIAlertAction(title: userNames[indexPath.row] + " doesn't have to pay", style: .default, handler: voteActionHandler)
                optionMenu.addAction(voteAction)
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            
            
            // Display the main menu
            present(optionMenu, animated: true, completion: nil)
        }
            
            
        else {
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
            
            let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
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
        if indexPath.section == 1 && indexPath.row == 1 {
            if indexPath == selectedIndexPath {
                return PickerViewTableViewCell.expandedHeight
            } else {
                
                
                return PickerViewTableViewCell.defaultHeight
            }
        }
        
        return 44
    }
}
