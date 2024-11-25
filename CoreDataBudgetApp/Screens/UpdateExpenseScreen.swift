//
//  UpdateExpenseScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-23.
//

import SwiftUI

struct UpdateExpenseScreen: View {

    @Environment(BudgetViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var expense: Expense

    @FocusState private var fieldIsFocused: Bool

    private var title: Binding<String> {
        Binding {
            expense.title ?? ""
        } set: { newValue in
            expense.title = newValue
        }
    }

    private var amount: Binding<Double?> {
        Binding {
            expense.amount
        } set: { newValue  in
            expense.amount = newValue ?? 0.0
        }
    }

    var body: some View {
        Form {
            ExpenseFormView(
                title: title,
                amount: amount,
                fieldIsFocused: $fieldIsFocused,
                sectionHeaderText: ""
            )
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Update Expense")
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.updateExpense(for: expense)
                    dismiss()
                } label: {
                    Text("Update")
                }.accessibilityLabel("Update Expense Item and dismiss")
            }
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .accessibilityLabel("Cancel and dismiss")
            }
        }
    }
}

//MARK: - Container view for preview
struct UpdateExpenseContainer: View {

    @Environment(BudgetViewModel.self) private var vm

    var body: some View {
        VStack {
            if let expense = vm.expenses.first {
                UpdateExpenseScreen(expense: expense)
            }
        }.task {
            vm.fetchBudgets()
            if let budget = vm.budgets.first {
                vm.fetchExpense(for: budget)
            }
        }
    }
}

#Preview {

    let context = CoreDataProvider.preview.context
    let vm = BudgetViewModel(context: context)

    NavigationStack {
        UpdateExpenseContainer()
    }
    .environment(\.managedObjectContext, context)
    .environment(vm)
}
