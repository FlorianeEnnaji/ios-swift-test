//
//  NoteDetailViewController.swift
//  TestApp
//
//  Created by Floriane Ennaji on 02/07/2017.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation
import UIKit

class NoteDetailViewController : UIViewController {
    
    var selectedNote: NoteModel? = nil
    
    @IBOutlet weak var dateOfCreationLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
        
        dateOfCreationLabel.text = dateFormatter.string(from: selectedNote!.dateOfCreation)
        
        contentTextView.text = selectedNote?.content
    }
}
