//
//  TasksTableViewController.swift
//  Roomies
//
//  Created by Mary Huerta on 1/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
   
    var countDownString = "Hours Left: "
    var countDownDouble = 0.0
    var tasks: [TaskMO] = []
    var fetchResultController: NSFetchedResultsController<TaskMO>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                   tasks = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    
    
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
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cellIdentifier = "TaskCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell
     
     // Configure the cell...
        
        countDownDouble = tasks[indexPath.row].duedate/360
        if (countDownDouble > 24.0){
            countDownDouble/=60
            countDownString = "Days Left: "
        }
        countDownString += " \(String(Int(countDownDouble))) "
        
        
        cell.taskName.text = tasks[indexPath.row].name
        cell.taskDueDate.text = countDownString
        cell.taskOwners.text = tasks[indexPath.row].owner
        
        return cell
    }
    
    // MARK: - Segue and Passing Data
    
    @IBAction func unwindTasks(segue:UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Delete Button
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let listToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(listToDelete)
                
                appDelegate.saveContext()
            }
        })
        
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
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
            tasks = fetchedObjects as! [TaskMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    



}
