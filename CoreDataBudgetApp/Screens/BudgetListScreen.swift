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
        ZStack {
            List {
                ForEach(budgets, id: \.id) { budget in
                    BudgetListItem(budget: budget)
                        .accessibilityLabel("Budget List item")
                }
                .listRowBackground(
                    RoundedRectangle(
                        cornerRadius: 12
                    ).fill(
                        .thinMaterial
                    )
                )
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Budget App")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                }
                .accessibilityLabel("Add new budget")
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddBudgetScreen().padding(.top, 16)
            }
            .presentationBackground(.thinMaterial)
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
