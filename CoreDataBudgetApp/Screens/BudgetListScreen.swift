//
//  BudgetListScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

struct BudgetListScreen: View {

    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.dateCreated)
        ]
    ) private var budgets: FetchedResults<Budget>

    @State private var isPresented: Bool = false

    private var backgroundColors: [Color] {
        [.pink, .magenta, .pink, .magenta, .white, .magenta]
    }

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

            BackgroundGradientView(colors: backgroundColors)

            if budgets.isEmpty {
                ContentUnavailableView(
                    "Add a Budget.",
                    systemImage: "creditcard"
                )
                .background(.ultraThinMaterial)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                .foregroundStyle(.white)
                
            } else {
                List {
                    ForEach(budgets, id: \.id) { budget in
                        NavigationLink(value: budget) {
                            BudgetListItemView(budget: budget)
                                .padding(.trailing, 8)
                                .accessibilityLabel("Budget List item")
                        }
                    }
                    .onDelete(perform: deleteBudget)
                    .listRowBackground(BackgroundThemeView())
                }.scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Budgets")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
                    .accessibilityLabel("Edit Buddget Items")
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
        .tint(.white)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddBudgetScreen()
                    .preferredColorScheme(.dark)
                    .padding(.top, 16)
            }
            .presentationBackground(.thinMaterial)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
            .navigationDestination(for: Budget.self) { budget in
                BudgetDetailScreen(budget: budget)
            }
    }.environment(
        \.managedObjectContext,
         CoreDataProvider.preview.context
    )
}
