//
//  AddTaskTableViewController.swift
//  Roomies
//
//  Created by Mary Huerta on 1/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class AddTaskTableViewController: UITableViewController {
    
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDueDatePicker: UIDatePicker!
    
    let addTask = Task()
    var task:Task!
    var taskNametext = ""
    
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            
            
            let user = FIRAuth.auth()?.currentUser
            
            print("Name: \(String(describing: taskNameTextField.text))")
            print("Date: \(taskDueDatePicker.date)")
            print("Date: \(taskDueDatePicker.countDownDuration)")
            
            
            addTask.name = taskNameTextField.text
            addTask.dueDate = taskDueDatePicker.date
          
            
            
            
            let childStr = "groups/\(localGroup.id)/tasks"
            let key = ref.child(childStr).childByAutoId().key
            let task: [String:Any] = [
                "name": addTask.name!,
                "due": addTask.dueDate?.timeIntervalSince1970,
                "owner": user!.displayName
                            ]
            
            ref.child(childStr).child(key).setValue(task)
            
            print("new task")
            print(user!.displayName)
            
            
            print("Saving data to context ...")
            
        }
        
    }
}


