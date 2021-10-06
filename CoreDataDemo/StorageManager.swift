//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Igor on 06.10.2021.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    

    
    init() {
        
    }
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }

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
    
    func fetchData() -> [Task]? {
        let fetchRequest = Task.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch data", error)
        }
        return nil
    }
}
