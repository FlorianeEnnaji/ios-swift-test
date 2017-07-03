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
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
        if (selectedNote == nil) {
            selectedNote = NoteModel(content: "", dateOfCreation: Date())
        }
        dateOfCreationLabel.text = dateFormatter.string(from: selectedNote!.dateOfCreation)
        
        contentTextView.text = selectedNote?.content
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
}
