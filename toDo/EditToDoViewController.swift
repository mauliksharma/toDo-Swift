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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = toDoItem?.title
        descTextView.text = toDoItem?.desc
        descTextView.textColor = UIColor.gray
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        toDoItem?.title = textField.text
        try? context.save()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        toDoItem?.title = textField.text
        try? context.save()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == UIColor.gray {
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        textView.textColor = UIColor.gray
        toDoItem?.desc = textView.text
        try? context.save()
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
