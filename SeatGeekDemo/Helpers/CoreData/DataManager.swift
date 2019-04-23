//
//  DataManager.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation
import CoreData

let entityName = "FavouriteEvent"
let attributeName = "eventId"
// A singleton class used to manage offline data
// Uses coredata to manage data
class DataManager: NSObject {

    static let shared = DataManager()
    var favouriteEvents = [NSManagedObject]()

    override init() {
        super.init()
        self.fetchFavouriteEvents()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EventFavourites")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchFavouriteEvents() {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            favouriteEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func isFavourite(eventId: String) -> Bool {
        let filteredList = favouriteEvents.filter { $0.value(forKeyPath: attributeName) as? String == eventId }
        return filteredList.count > 0
    }

    func delete(favouriteEventId: String) {
        let managedContext = self.persistentContainer.viewContext
        let filteredList = favouriteEvents.filter { $0.value(forKeyPath: attributeName) as? String == favouriteEventId }
        for object in filteredList {
            managedContext.delete(object)
            if let index = favouriteEvents.firstIndex(of: object) {
                favouriteEvents.remove(at: index)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            // Do nothing
        }
    }

    func save(favouriteEventId: String) {
        let managedContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                in: managedContext)!

        let event = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        event.setValue(favouriteEventId, forKeyPath: attributeName)
        do {
            try managedContext.save()
            favouriteEvents.append(event)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
