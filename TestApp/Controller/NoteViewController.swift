//
//  NoteViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var noteTable: [NoteModel] = []
    var selectedNote: NoteModel? = nil
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let manager = NoteController.sharedInstance
        noteTable = manager.getAllNotes()
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = dateFormatter.string(from: noteTable[indexPath.row].dateOfCreation) + " - " + noteTable[indexPath.row].content
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedNote = noteTable[indexPath.row]
        performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailView" && (selectedNote != nil)) {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! NoteDetailViewController
            // your new view controller should have property that will store passed value
            viewController.selectedNote = selectedNote!
        }
    }


}

