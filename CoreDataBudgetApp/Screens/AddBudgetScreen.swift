//
//  AddBudgetScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import SwiftUI

struct AddBudgetScreen: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var limit: Double?
    @State private var errorMessage: String?

    private var isFormValid: Bool {
        guard let limit else { return false }
        return !title.isEmptyOrWhitespace && Double(limit) > 0
    }

    private func saveBudgetItem() {

        let budget = Budget(context: context)
        budget.title = title
        budget.amount = limit ?? 0.0
        budget.dateCreated = Date()

        do {
            try context.save()
        } catch {
            errorMessage = "Unable to save budget."
        }
    }

    private func resetForm() {
        title = ""
        limit = nil
        errorMessage = nil
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                    .accessibilityLabel("Budget Title")
                    .accessibilityValue(title)
                TextField("Limit", value: $limit, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityLabel("Budget Limit")
                    .accessibilityValue("\(limit ?? 0) total limit for budget item")
            }
            .listRowBackground(Rectangle().fill(.thinMaterial))

            if let errorMessage {
                Section("Error") {
                    Text(errorMessage)
                        .accessibilityLabel("Error message")
                        .foregroundStyle(.pink)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("New Budget")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if Budget.exists(context: context, title: title) {
                        errorMessage = "Budget already exists for this title."
                        return
                    }

                    saveBudgetItem()
                    resetForm()
                    dismiss()
                } label: {
                    Text("Save")
                }
                .disabled(!isFormValid)
                .accessibilityLabel("Save Budget Item and dismiss")
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

#Preview {
    NavigationStack {
        AddBudgetScreen()
    }
    .environment(
        \.managedObjectContext,
         CoreDataProvider.preview.context
    )
}
