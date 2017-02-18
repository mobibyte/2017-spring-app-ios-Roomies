//
//  ExpensesTableViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 11/4/16.
//  Copyright © 2016 Mobi. All rights reserved.
//
import UIKit
import CoreData

class ExpensesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var sorterSegmentedControl: UISegmentedControl!
    
    
    var amountText = ""
    
    var userNames = ["Bruce", "Wade", "Logan"]
    var userDict = [String: [String]] ()
    var userSectionTitles = [String] ()
    
    var expenseTypes = [ "Rent", "Bills", "Entertainment", "Food", "Other" ]
    
    var expenses: [Expense] = []
    
    var fetchResultController: NSFetchedResultsController<ExpenseMO>!
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func DoneExpense(segue: UIStoryboardSegue){
        let newExpense = Expense()
        let addExpense = segue.source as! AddExpenseTableViewController
        
        newExpense.username = addExpense.addExpense.username
        newExpense.amount = addExpense.addExpense.amount
        newExpense.title = addExpense.addExpense.title
        newExpense.type = addExpense.addExpense.type
        newExpense.emoji = addExpense.addExpense.emoji
        
        expenses.append(newExpense)
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseViewControllerUtil.setup(viewController: self)
    }
    
    
    @IBAction func segmentChange(_ sender: Any) {
        viewDidLoad()
        tableView.reloadData()
        
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
        
        // Configure the cell...
        
        cell.expenseAmount.text = ("$" + expenses[indexPath.row].amount!)
        cell.expenseTitle.text =   expenses[indexPath.row].title!
        cell.expenseForUser.text = ("Owed to " + expenses[indexPath.row].username!)
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
            
            self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        deleteAction.backgroundColor = UIColor(red: 210/255.0, green: 77/255.0, blue: 89/255.0, alpha: 1.0)
        
        return [deleteAction]
        
    }
    
    
    
}
