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
    @FocusState private var fieldIsFocused: Bool

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
        fieldIsFocused = false
    }

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    .teal,
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Form {
                List {
                    CustomListIemView(label: "Remaining:", value: remaining)
                        .font(.title)
                        .padding(.vertical, 4)
                        .foregroundStyle(remaining > 0 ? .green : .red)
                    CustomListIemView(label: "Total Expenses:", value: total)
                }.listRowBackground(Rectangle().fill(.thinMaterial))

                Section("New Expense") {
                    TextField("Title", text: $title)
                        .focused($fieldIsFocused)
                        .accessibilityLabel("Expense Title")
                        .accessibilityValue(title)
                    TextField("Amount", value: $amount, format: .number)
                        .focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
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
                }
                .tint(.green)
                .listRowBackground(Rectangle().fill(.thinMaterial))
                .disabled(!isFormValid)

                if let errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .accessibilityLabel("Error message")
                            .foregroundStyle(.pink)
                    }.listRowBackground(Rectangle().fill(.thinMaterial))
                }

                Section("Expenses") {
                    if expenses.isEmpty {
                        ContentUnavailableView("Add an expense.", systemImage: "cart.badge.plus")
                            .listRowBackground(Rectangle().fill(.thinMaterial))
                            .foregroundStyle(.mint)
                    } else {
                        List {
                            ForEach(expenses, id: \.id) { expense in
                                ExpenseListView(expense: expense)
                            }
                            .onDelete(perform: deleteExpense)
                        }.listRowBackground(Rectangle().fill(.thinMaterial))
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .scrollContentBackground(.hidden)
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
