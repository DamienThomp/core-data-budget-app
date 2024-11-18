//
//  Budget+Extensions.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import Foundation
import CoreData

extension Budget {
    
    static func exists(context: NSManagedObjectContext, title: String) -> Bool {

        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            return false
        }
    }
}
