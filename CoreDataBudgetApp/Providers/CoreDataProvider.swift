//
//  CoreDataProvider.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import Foundation
import CoreData

final class CoreDataProvider {
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")

        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
}
