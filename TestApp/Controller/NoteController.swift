//
//  NoteController.swift
//  TestApp
//
//  Created by Floriane Ennaji on 02/07/2017.
//  Inspired by Ray Wenderlich's tutorial on Core Data : https://www.raywenderlich.com/145809/getting-started-core-data-tutorial
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoteController {
    
    static let sharedInstance = NoteController()
    
    func create(dateOfCreation: Date) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Note",
                                       in: managedContext)!
        
        let note = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        note.setValue(dateOfCreation, forKeyPath: "dateOfCreation")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not create note. \(error), \(error.userInfo)")
        }
    }
    
    func updateContent(note: NoteModel) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "dateOfCreation == %@", note.dateOfCreation as CVarArg)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let currentNote = results.first
            currentNote?.setValue(note.content, forKeyPath: "content")
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func delete(note: NoteModel) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "dateOfCreation == %@", note.dateOfCreation as CVarArg)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let currentNote = results.first
            managedContext.delete(currentNote!)
            
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    func getAllNotes() -> [NoteModel] {
        var notes: [NoteModel] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)

            for result in results {
                let content = result.value(forKey: "content")! as! String
                let date = result.value(forKey: "dateOfCreation")! as! Date
                
                notes.append(NoteModel(content: content, dateOfCreation: date))
            }
        } catch let error as NSError {
            print("Could not get notes. \(error), \(error.userInfo)")
        }
        
        return notes
    }
    
}
