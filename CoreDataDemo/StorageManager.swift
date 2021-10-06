//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Igor on 06.10.2021.
//

import CoreData

class StorageManager {
    var lastSavedObject: Task? { fetchData().last }
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        persistentContainer = container
        context = container.viewContext

    }
    

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch data", error)
        }
        return []
    }
    
    func saveNewObject(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        
        saveContext()
    }
    
    func deleteObject(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func editObject(task: Task, completionHandler: () -> Void) {
        
    }
}
