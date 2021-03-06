//
//  NoteDetailViewController.swift
//  TestApp
//
//  Created by Floriane Ennaji on 02/07/2017.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation
import UIKit

class NoteDetailViewController : UIViewController, UITextViewDelegate {
    
    var selectedNote: NoteModel? = nil
    let manager = NoteController.sharedInstance
    
    @IBOutlet weak var dateOfCreationLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contentTextView.delegate = self
        
        //Add notifications when keyboard shows up or disappear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
        if (selectedNote == nil) {
            selectedNote = NoteModel(content: "", dateOfCreation: Date())
        }
        dateOfCreationLabel.text = dateFormatter.string(from: selectedNote!.dateOfCreation)
        
        contentTextView.text = selectedNote?.content
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove notifications from keyboard
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "backToListView", sender: self)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        //Verify that the content is not empty
        if (contentTextView.text.characters.count > 0) {
            //If the content is empty, it means it's a new note
            if (selectedNote!.content == "") {
                manager.create(dateOfCreation: selectedNote!.dateOfCreation)
            }
            selectedNote!.content = contentTextView.text
            manager.updateContent(note: selectedNote!)
            
            performSegue(withIdentifier: "backToListView", sender: self)
        } else {
            let alertController = UIAlertController(title: "Note is empty", message:
                "Please don't save an empty note", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        //If the content is empty, it means it's a new note
        if (selectedNote!.content != "") {
            manager.delete(note: selectedNote!)
        }
        performSegue(withIdentifier: "backToListView", sender: self)
    }
    
    func keyboardWasShown(notification: NSNotification){
        self.contentTextView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.contentTextView.contentInset = contentInsets
        self.contentTextView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.contentTextView.contentInset = contentInsets
        self.contentTextView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.contentTextView.isScrollEnabled = false
    }
}
