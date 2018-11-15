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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Pending" : "Completed"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? toDosPending.count : toDosCompleted.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let toDo = indexPath.section == 0 ? toDosPending[indexPath.row] : toDosCompleted[indexPath.row]
        cell.textLabel?.text = toDo.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let toDoItem = toDosPending[indexPath.row]
            performSegue(withIdentifier: "editToDo", sender: toDoItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toDoItem = indexPath.section == 0 ? toDosPending[indexPath.row] : toDosCompleted[indexPath.row]
        let completedAction = UIContextualAction(style: .normal, title: "Done") { (action, view, handler) in
            toDoItem.completed = !toDoItem.completed
            try? self.context.save()
            self.fetchToDos()
            tableView.reloadData()
        }
        completedAction.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [completedAction])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let toDoItem = indexPath.section == 0 ? toDosPending[indexPath.row] : toDosCompleted[indexPath.row]
        if editingStyle == .delete {
            context.delete(toDoItem)
            try? context.save()
            fetchToDos()
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
