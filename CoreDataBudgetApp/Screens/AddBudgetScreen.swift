//
//  AddBudgetScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import SwiftUI

struct AddBudgetScreen: View {

    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var limit: Double?

    private var isFormValid: Bool {
        !title.isEmpty && limit != nil
    }

    var body: some View {
        Form {
            Section(header: Text("New Budget")) {
                TextField("Title", text: $title)
                    .accessibilityLabel("Budget Title")
                    .accessibilityValue(title)
                TextField("Limit", value: $limit, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityLabel("Budget Limit")
                    .accessibilityValue("\(limit ?? 0) total limit for budget item")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: handle save action
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
}
