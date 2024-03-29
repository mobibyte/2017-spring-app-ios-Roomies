//
//  ExpensesTableViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 11/4/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class ExpensesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

   
    @IBOutlet var sorterSegmentedControl: UISegmentedControl!
   
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    var amountText = ""
    var expenses = [Expense]()
    let ref = FIRDatabase.database().reference()
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToExpenses(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func DoneExpense(segue: UIStoryboardSegue){

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseViewControllerUtil.setup(viewController: self)
        
        // Listen pho data
        ref.child("groups/\(localGroup.id)/expenses").observe(.childAdded, with: { (snapshot) in
        
            if let value = snapshot.value as? [String:Any] {
                let E = Expense()
                E.id = snapshot.key
                E.amount = value["amount"] as? String
                E.emoji = value["emoji"] as? String
                E.title = value["title"] as? String
                E.type = value["type"] as? String
                E.username = value["username"] as? String
                self.expenses.append(E)
                
            }
            
            self.tableView.reloadData()
        })
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExpenseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpenseTableViewCell
        
        cell.expenseAmount.text = ("$" + expenses[indexPath.row].amount!)
        cell.expenseTitle.text =   expenses[indexPath.row].title!
        cell.expenseForUser.text = ("Owed to \((localGroup.members[expenses[indexPath.row].username!])!.name)")
        cell.expenseCategory.text = expenses[indexPath.row].type

        cell.emojiImage.text = expenses[indexPath.row].emoji
        
        return cell
    }
    
    
    // MARK: - Delete Expense Edit Action
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
        
            print(self.expenses[indexPath.row].id!)
            print(indexPath.row)
            
            self.ref.child("groups/\(self.localGroup.id)/expenses/\(self.expenses[indexPath.row].id!)").removeValue { (error, ref) in
                print(indexPath.row)
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
            self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(indexPath.row)
            
        })

        deleteAction.backgroundColor = UIColor(red: 210/255.0, green: 77/255.0, blue: 89/255.0, alpha: 1.0)
        
        return [deleteAction]
        
    }
   
    

}
