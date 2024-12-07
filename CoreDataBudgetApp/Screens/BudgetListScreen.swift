//
//  BudgetListScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

struct BudgetListScreen: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(BudgetViewModel.self) private var viewModel
    @State private var isPresented: Bool = false

    private var backgroundColors: [Color] {
        [.pink, .magenta, .pink, .magenta, .lightMagenta, .magenta, .darkPink, .darkPink, .darkPink]
    }

    var body: some View {
        ZStack {

            BackgroundGradientView(colors: backgroundColors)

            if viewModel.budgets.isEmpty {
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
                    ForEach(viewModel.budgets, id: \.id) { budget in
                        NavigationLink(value: budget) {
                            BudgetListItemView(budget: budget)
                                .padding(.trailing, 8)
                                .accessibilityLabel("Budget List item")
                        }
                    }
                    .onDelete(perform: viewModel.deleteBudget)
                    .listRowBackground(ListRowBackgroundTheme())
                }.scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Budgets")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {

                EditButton()
                    .disabled(viewModel.budgets.isEmpty)
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
        .onAppear {
            viewModel.fetchBudgets()
        }
    }
}

#Preview("Default English") {

    let context = CoreDataProvider.preview.context
    let vm = BudgetViewModel(context: context)

    NavigationStack {
        BudgetListScreen()
            .navigationDestination(for: Budget.self) { budget in
                BudgetDetailScreen(budget: budget)
            }
    }
    .environment(\.managedObjectContext, context)
    .environment(vm)
}

#Preview("French") {
    let context = CoreDataProvider.preview.context
    let vm = BudgetViewModel(context: context)

    NavigationStack {
        BudgetListScreen()
            .navigationDestination(for: Budget.self) { budget in
                BudgetDetailScreen(budget: budget)
            }
    }
    .environment(\.locale, .init(identifier: "fr_CA"))
    .environment(\.managedObjectContext, context)
    .environment(vm)
}
