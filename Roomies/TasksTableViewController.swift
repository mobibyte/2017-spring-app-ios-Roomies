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
    let userCalendar = NSCalendar.current
    
    var tasks: [Task] = []
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
                    for fetched in fetchedObjects {
                        let task = Task()
                        task.name = fetched.name
                        task.dueDate = fetched.duedate as? Date
                        task.owner = fetched.owner
                        
                        tasks.append(task)
                    }
                   
                    self.tableView.reloadData()
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
        
        let task = tasks[indexPath.row]
        
        // TODO: Wrap duedate optional
        let calendar = Calendar.current
        let dueDays = calendar.component(.day, from: task.dueDate!)
        let dueHours = calendar.component(.hour, from: task.dueDate!)
        
 
        //CountDownDoubleDifference.day
        if (dueDays > 1){
            cell.taskDueDate.text = "\(dueDays) days left"
            
        } else {
            cell.taskDueDate.text = "\(dueHours) hours left"
        }
        
        cell.taskName.text = task.name
        cell.taskOwners.text = task.owner
    
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
            //tasks = fetchedObjects as! [Task]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    



}
