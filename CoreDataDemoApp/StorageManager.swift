//
//  StorageManager.swift
//  CoreDataDemoApp
//
//  Created by mac on 30.06.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static var shared = StorageManager()
    
    private init() {}

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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

    func save(_ taskName: String) -> Task {
        if let entityDescription = NSEntityDescription
            .entity(forEntityName: "Task", in: persistentContainer.viewContext) {
            if let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task {
                task.name = taskName
                return task
            }
        }

        return Task()
    }


    func saveData() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return []
    }
    
}
