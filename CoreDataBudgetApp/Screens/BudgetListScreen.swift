//
//  BudgetListScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

struct BudgetListScreen: View {

    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false

    var body: some View {
        List {
            ForEach(budgets, id: \.id) { budget in
                Text(budget.title ?? "")
            }
        }
        .navigationTitle("Budget App")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddBudgetScreen()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }.environment(
        \.managedObjectContext,
         CoreDataProvider.preview.context
    )
}
