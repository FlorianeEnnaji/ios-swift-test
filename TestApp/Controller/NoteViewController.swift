//
//  NoteViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet var tableView: UITableView!
    
    var noteTable: [NoteModel] = []
    var filteredNotes: [NoteModel] = []
    var selectedNote: NoteModel? = nil
    let dateFormatter = DateFormatter()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        let manager = NoteController.sharedInstance
        noteTable = manager.getAllNotes()
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!searchController.isActive) {
            return noteTable.count
        } else {
            return filteredNotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if (!searchController.isActive) {
            cell.textLabel?.text = dateFormatter.string(from: noteTable[indexPath.row].dateOfCreation) + " - " + noteTable[indexPath.row].content
        } else {
           cell.textLabel?.text = dateFormatter.string(from: filteredNotes[indexPath.row].dateOfCreation) + " - " + filteredNotes[indexPath.row].content
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (!searchController.isActive) {
            selectedNote = noteTable[indexPath.row]
        } else {
            selectedNote = filteredNotes[indexPath.row]
        }
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
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filteredNotes = noteTable.filter { currentNote in
            return currentNote.content.lowercased().contains((searchText?.lowercased())!)
        }
        tableView.reloadData()
    }


}

