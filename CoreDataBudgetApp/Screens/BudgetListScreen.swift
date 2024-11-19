//
//  BudgetListScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

struct BudgetListScreen: View {

    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false

    private func deleteBudget(at offsets: IndexSet) {

        for index in offsets {
            let budget = budgets[index]
            context.delete(budget)
        }

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        ZStack {
            List {
                ForEach(budgets, id: \.id) { budget in
                    NavigationLink {
                        BudgetDetailScreen(budget: budget)
                    } label: {
                        BudgetListItem(budget: budget)
                            .padding(.trailing, 8)
                            .accessibilityLabel("Budget List item")
                    }
                }
                .onDelete(perform: deleteBudget)
                .listRowBackground(
                    RoundedRectangle(
                        cornerRadius: 12
                    ).fill(
                        .thinMaterial
                    )
                )
            }
            .padding(.top)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Budgets")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
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
