//
//  ExpenseFormView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-23.
//

import SwiftUI

struct ExpenseFormView: View {

    @Binding var title: String
    @Binding var amount: Double?
    @FocusState.Binding var fieldIsFocused: Bool

    let sectionHeaderText: String

    var body: some View {
        Section(sectionHeaderText) {
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
                .accessibilityValue("\(amount ?? 0.0) total amount for expense")
        }
        .listRowBackground(ListRowBackgroundTheme())
    }
}

#Preview {
    ExpenseFormView(title: .constant(""), amount: .constant(0), fieldIsFocused: FocusState<Bool>().projectedValue, sectionHeaderText: "New Expense")
}
