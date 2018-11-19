//
//  EditToDoViewController.swift
//  toDo
//
//  Created by Maulik Sharma on 15/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import CoreData

class EditToDoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let context = AppDelegate.viewContext
    
    var toDoItem: ToDoItem?
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    
    @IBOutlet weak var descTextView: UITextView! {
        didSet {
            descTextView.delegate = self
        }
    }
    
    let defaultTitle = "New todo"
    let defaultDesc = "Describe it here..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "paper.jpg")!)
        titleTextField.text = toDoItem?.title ?? defaultTitle
        descTextView.text = toDoItem?.desc ?? defaultDesc
        descTextView.textColor = UIColor.gray
        saveData()
    }
    
    func saveData() {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let currentDate = dateFormatter.string(from: date)
        toDoItem?.date = currentDate
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let currentTime = timeFormatter.string(from: date)
        toDoItem?.time = currentTime
        
        toDoItem?.title = titleTextField.text != "" ? titleTextField.text : defaultTitle
        toDoItem?.desc = descTextView.text != "" ? descTextView.text : defaultDesc
        
        try? context.save()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveData()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == defaultTitle {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveData()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == defaultDesc {
            textView.text = ""
        }
        if textView.textColor == UIColor.gray {
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        textView.textColor = UIColor.gray
        saveData()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
