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

    static var preview: CoreDataProvider = {

        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context

        let previewBudget = Budget(context: context)
        previewBudget.title = "Preview Budget"
        previewBudget.amount = 100
        previewBudget.dateCreated = Date()

        let previewExpense = Expense(context: context)
        previewExpense.title = "Some Expense"
        previewExpense.amount = 15
        previewExpense.dateCreated = Date()

        previewBudget.addToExpenses(previewExpense)

        do {
            try context.save()
        } catch {
            print(error)
        }

        return provider
    }()

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
