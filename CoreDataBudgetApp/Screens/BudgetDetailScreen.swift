//
//  BudgetDetailScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import SwiftUI

struct BudgetDetailScreen: View {

    @Environment(BudgetViewModel.self) private var viewModel

    @State private var title: String = ""
    @State private var amount: Double?
    @FocusState private var fieldIsFocused: Bool

    let budget: Budget

    private var remaining: Double {
        budget.amount - viewModel.totalExpenses
    }

    private var isFormValid: Bool {

        guard let amount else { return false }

        return !title.isEmptyOrWhitespace && Double(amount) > 0
    }

    private var backgroundColors: [Color] {

        [
            .teal, .cyan, .teal,
            .cyan, .lightTeal, .cyan,
            .darkTeal, .darkTeal, .darkTeal
        ]
    }

    private var sectionTitleColor: Color {

        if #available(iOS 18.0, *) {
            return .black
        } else {
            return .white
        }
    }

    private func saveExpense() {
        viewModel.saveExpense(for: budget, title: title, amount: amount ?? 0.0)
    }

    private func deleteExpense(at offsets: IndexSet) {
        viewModel.deleteExpense(at: offsets, for: budget)
    }

    private func resetForm() {

        title = ""
        amount = nil
        fieldIsFocused = false
        viewModel.errorMessage = nil
    }

    var body: some View {

        ZStack {

            BackgroundGradientView(colors: backgroundColors)

            List {

                Section {
                    CustomListIemView(label: "Remaining:", value: remaining)
                        .font(.title)
                        .padding(.vertical, 4)
                        .foregroundStyle(remaining > 0 ? .green : .red)
                    CustomListIemView(label: "Total Expenses:", value: viewModel.totalExpenses)
                }.listRowBackground(ListRowBackgroundTheme())

                Section("New Expense") {
                    TextField("Title", text: $title)
                        .focused($fieldIsFocused)
                        .foregroundStyle(.white)
                        .accessibilityLabel("Expense Title")
                        .accessibilityValue(title)
                    TextField("Amount", value: $amount, format: .number)
                        .foregroundStyle(.white)
                        .focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Expense Amount")
                        .accessibilityValue("\(amount ?? 0) total amount for expense")
                }
                .listRowBackground(ListRowBackgroundTheme())
                .foregroundStyle(sectionTitleColor)

                Button {
                    saveExpense()
                    resetForm()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!isFormValid)
                .tint(.green)
                .listRowBackground(ListRowBackgroundTheme())


                if let errorMessage = viewModel.errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .accessibilityLabel("Error message")
                            .foregroundStyle(.pink)
                    }
                    .listRowBackground(ListRowBackgroundTheme())
                    .foregroundStyle(sectionTitleColor)
                }

                Section("Expenses") {
                    if viewModel.expenses.isEmpty {
                        ContentUnavailableView(
                            "Add an expense.",
                            systemImage: "cart.badge.plus"
                        )
                        .foregroundStyle(.mint)
                    }
                    ForEach(viewModel.expenses, id: \.id) { expense in
                        ExpenseListView(expense: expense).foregroundStyle(.white)
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listRowBackground(ListRowBackgroundTheme())
                .foregroundStyle(sectionTitleColor)
            }
        }
        .onAppear { viewModel.fetchExpense(for: budget) }
        .preferredColorScheme(.dark)
        .scrollContentBackground(.hidden)
        .navigationTitle(budget.title ?? "Budget")
    }
}

// MARK: - Container view for preview rendering with budget
struct BudgetDetailScreenContainer: View {

    @Environment(BudgetViewModel.self) private var vm

    var body: some View {
        VStack {
            if let budget = vm.budgets.first {
                BudgetDetailScreen(budget: budget)
            } else {
                EmptyView()
            }

        }.onAppear { vm.fetchBudgets() }
    }
}

#Preview {
    let context = CoreDataProvider.preview.context
    let vm = BudgetViewModel(context: context)

    NavigationStack {
        BudgetDetailScreenContainer()
            .environment(vm)
    }
}
