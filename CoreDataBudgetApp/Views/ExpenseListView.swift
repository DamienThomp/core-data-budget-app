//
//  ExpenseListView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import SwiftUI

struct ExpenseListView: View {

    let expense: Expense

    var body: some View {
        HStack {
            Image(systemName: "creditcard.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.green)
                .font(.title2)
                .imageScale(.large)
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(expense.title ?? "")
                Text(
                    expense.dateCreated ?? Date(),
                    format: .dateTime.day().month().year()
                )
                .font(.caption)
            }

            Spacer()

            Text(
                expense.amount,
                format: .currency(
                    code: Locale.current.currencyCode
                )
            )
        }
    }
}

