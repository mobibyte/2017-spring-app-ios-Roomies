//
//  AddTaskTableViewController.swift
//  Roomies
//
//  Created by Mary Huerta on 1/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddTaskTableViewController: UITableViewController {
    
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDueDatePicker: UIDatePicker!
    
    let addTask = Task()
    var task:Task!
    var taskNametext = ""
    
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //    @IBAction func saveTask(sender: AnyObject) {
    //        if taskNameTextField.text == ""  {
    //            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
    //            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            alertController.addAction(alertAction)
    //            present(alertController, animated: true, completion: nil)
    //        }
    //
    //        print("Name: \(taskNameTextField.text)")
    //        print("Date: \(taskDueDatePicker.date)")
    //        print("Date: \(taskDueDatePicker.countDownDuration)")
    //
    //        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
    //            task = TaskMO(context: appDelegate.persistentContainer.viewContext)
    //            task.name = taskNameTextField.text
    //
    //            task.duedate = taskDueDatePicker.date as NSDate?
    //
    //
    //            print("Saving data to context ...")
    //            appDelegate.saveContext()
    //
    //        }
    //
    //        dismiss(animated: true, completion: nil)
    //
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            
            
            print("Name: \(taskNameTextField.text)")
            print("Date: \(taskDueDatePicker.date)")
            print("Date: \(taskDueDatePicker.countDownDuration)")
            
            
            addTask.name = taskNameTextField.text
            addTask.dueDate = taskDueDatePicker.date
            
            
            let userData = (UIApplication.shared.delegate as! AppDelegate).tempUserData
            
            if let group = userData?["group"] as? String {
                let childStr = "groups/\(group)/tasks"
                let key = ref.child(childStr).childByAutoId().key
                let task: [String:Any] = [
                    "name": addTask.name!,
                    "due": Int((addTask.dueDate?.timeIntervalSince1970)!)
                ]
                
                ref.child(childStr).child(group).setValue(task)
            }
            
            print("new task")
            print(userData?["group"])
            
            
            
            print("Saving data to context ...")
            
        }
        
    }
}


