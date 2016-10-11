//
//  ViewController.swift
//  ToDoList
//
//  Created by Pavan Powani on 11/10/16.
//  Copyright © 2016 Pavan Powani. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {

    
    
    @IBOutlet weak var tableview: UITableView!
    var items = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To-Do"
        tableview.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        
     
    }
//method to save added data to core data
    func saveName(name: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("ToDoItem",
            inManagedObjectContext:managedContext)
        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)

        item.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
// method to add items
    @IBAction func add(sender: AnyObject) {
        let alert = UIAlertController(title: "New Item",
            message: "Add a new item",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
                self.tableview.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
//end method to add items
    
    
//methods responsible displaying the tableview
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return items.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            let item = items[indexPath.row]
            
            cell!.textLabel!.text =
                item.valueForKey("name") as? String
            
            return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
        
        let cell = items[indexPath.row]
        
        managedContext.deleteObject(cell)
        
        do {
        try managedContext.save()
        } catch let error as NSError {
        print("Could not save: \(error)")
     }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}
    
//    fetching persisted data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "ToDoItem")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            items = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}

