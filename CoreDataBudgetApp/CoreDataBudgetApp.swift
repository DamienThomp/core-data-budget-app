//
//  CoreDataBudgetApp.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

@main
struct CoreDataBudgetApp: App {

    let provider: CoreDataProvider

    init() {
        provider = CoreDataProvider()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BudgetListScreen()
                    .environment(\.managedObjectContext, provider.context)
            }
        }
    }
}
