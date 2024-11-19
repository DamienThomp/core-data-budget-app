//
//  BudgetDetailScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import SwiftUI

struct BudgetDetailScreen: View {

    @Environment(\.managedObjectContext) private var context

    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>

    let budget: Budget

    init(budget: Budget) {

        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }

    @State private var title: String = ""
    @State private var amount: Double?
    @State private var errorMessage: String?

    private var total: Double {
        expenses.reduce(0) { result, expense in
            return expense.amount + result
        }
    }

    private var remaining: Double {
        budget.amount - total
    }

    private var isFormValid: Bool {

        guard let amount else { return false }

        return !title.isEmptyOrWhitespace && Double(amount) > 0
    }

    private func saveExpense() {

        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0.0
        expense.dateCreated = Date()

        budget.addToExpenses(expense)

        do {
            try context.save()
        } catch {
            errorMessage = "Unable to save expense."
            print(error.localizedDescription)
        }
    }

    private func deleteExpense(at offsets: IndexSet) {

        for index in offsets {
            let expense = expenses[index]
            context.delete(expense)
        }

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func resetForm() {

        title = ""
        amount = nil
        errorMessage = nil
    }

    var body: some View {

        VStack {
            Form {
                List {
                    CustomListIemView(label: "Remaining:", value: remaining)
                        .font(.title)
                        .padding(.vertical, 4)
                        .foregroundStyle(remaining > 0 ? .green : .red)
                    CustomListIemView(label: "Total Expenses:", value: total)
                }

                Section("New Expense") {
                    TextField("Title", text: $title)
                        .accessibilityLabel("Expense Title")
                        .accessibilityValue(title)
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                        .accessibilityLabel("Expense Amount")
                        .accessibilityValue("\(amount ?? 0) total amount for expense")
                }
                .listRowBackground(Rectangle().fill(.thinMaterial))

                Button {
                    saveExpense()
                    resetForm()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }.disabled(!isFormValid)

                if let errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .accessibilityLabel("Error message")
                            .foregroundStyle(.pink)
                    }
                }
                Section("Expenses") {
                    List {
                        ForEach(expenses, id: \.id) { expense in
                            ExpenseListView(expense: expense)
                        }
                        .onDelete(perform: deleteExpense)
                    }
                }
            }
        }
        .padding(.top, 12)
        .navigationTitle(budget.title ?? "Budget")
    }
}

// MARK: - Container view for preview rendering with budget
struct BudgetDetailScreenContainer: View {

    @FetchRequest(sortDescriptors: [])  private var budgets: FetchedResults<Budget>

    var body: some View {
        BudgetDetailScreen(budget: budgets[0])
    }
}

#Preview {
    NavigationStack {
        BudgetDetailScreenContainer()
            .environment(
                \.managedObjectContext,
                 CoreDataProvider.preview.context
            )
    }
}
