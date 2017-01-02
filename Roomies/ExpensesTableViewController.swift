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
    
    var expenses: [ExpenseMO] = []
    var fetchResultController: NSFetchedResultsController<ExpenseMO>!
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch data from data store
        let fetchRequest: NSFetchRequest<ExpenseMO> = ExpenseMO.fetchRequest()
        let usernameSort = NSSortDescriptor(key: "username", ascending: true)
        let amountSort = NSSortDescriptor(key: "amount", ascending: true)
        let categorySort = NSSortDescriptor(key: "type", ascending: true)
        
        switch sorterSegmentedControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [usernameSort]
        case 1:
            fetchRequest.sortDescriptors = [amountSort]
        case 2:
            fetchRequest.sortDescriptors = [categorySort]
        default:
            fetchRequest.sortDescriptors = [amountSort]
        }
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    expenses = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    
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
        
        /*
        switch expenses[indexPath.row].type {
        case (expenseTypes[0])?:
            cell.expenseAmount.backgroundColor = UIColor(red: 0.8863, green: 0.6039, blue: 0.3176, alpha: 1.0)
        case (expenseTypes[1])?:
            cell.expenseAmount.backgroundColor = UIColor(red: 0.3333, green: 0.9294, blue: 0.4235, alpha: 1.0)
        case (expenseTypes[2])?:
            cell.expenseAmount.backgroundColor = UIColor(red: 0.5137, green: 0.302, blue: 0.8392, alpha: 1.0)
        case (expenseTypes[3])?:
            cell.expenseAmount.backgroundColor = UIColor(red: 0.8275, green: 0.298, blue: 0.4196, alpha: 1.0)
        default:
            cell.expenseAmount.backgroundColor = UIColor(red: 0.898, green: 0.8706, blue: 0.3216, alpha: 1.0)
        }*/
        
        
        //cell.expenseAmount.backgroundColor =

        return cell
    }
    
    
    // MARK: - Delete Expense Edit Action
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            expenses.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let context = appDelegate.persistentContainer.viewContext
                let expenseToDelete = self.fetchResultController.object(at: indexPath)
                
                context.delete(expenseToDelete)
                appDelegate.saveContext()
                
            }
        })

        deleteAction.backgroundColor = UIColor(red: 210/255.0, green: 77/255.0, blue: 89/255.0, alpha: 1.0)
        
        return [deleteAction]
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            expenses = fetchedObjects as! [ExpenseMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

   
    
       /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
