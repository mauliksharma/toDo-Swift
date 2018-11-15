//
//  ToDoTableViewController.swift
//  toDo
//
//  Created by Maulik Sharma on 15/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    let context = AppDelegate.viewContext
    
    var toDosPending = [ToDoItem]()
    var toDosCompleted = [ToDoItem]()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchToDos()
//        tableView.reloadData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchToDos()
        tableView.reloadData()
    }
    
    func fetchToDos() {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        if let toDoItems = try? context.fetch(request) {
            toDosPending = []
            toDosCompleted = []
            toDoItems.forEach { toDoItem in
                if !toDoItem.completed { toDosPending.append(toDoItem) } else { toDosCompleted.append(toDoItem) }
            }
        }
    }
    
    @IBAction func addToDo(_ sender: UIBarButtonItem) {
        let toDoItem = ToDoItem(context: context)
        toDoItem.title = "New ToDo"
        toDosPending.insert(toDoItem, at: 0)
        try? context.save()
        performSegue(withIdentifier: "editToDo", sender: toDoItem)
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editToDo" {
            if let toDoItem = sender as? ToDoItem {
                if let editToDoVC = segue.destination as? EditToDoViewController {
                    editToDoVC.toDoItem = toDoItem
                }
            }
        }
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return toDosPending.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let toDo = toDosPending[indexPath.row]
        cell.textLabel?.text = toDo.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDoItem = toDosPending[indexPath.row]
        performSegue(withIdentifier: "editToDo", sender: toDoItem)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDoItem = toDosPending[indexPath.row]
            toDosPending.remove(at: indexPath.row)
            context.delete(toDoItem)
            try? context.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
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

}
