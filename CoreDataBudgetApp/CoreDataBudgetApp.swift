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
    let budgetViewModel: BudgetViewModel

    init() {
        provider = CoreDataProvider()
        budgetViewModel = BudgetViewModel(context: provider.context)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BudgetListScreen()
                    .navigationDestination(for: Budget.self) { budget in
                        BudgetDetailScreen(budget: budget)
                    }
            }
            .environment(\.managedObjectContext, provider.context)
            .environment(budgetViewModel)
        }
    }
}
