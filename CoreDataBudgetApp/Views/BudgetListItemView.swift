//
//  BudgetListItemView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import SwiftUI

struct BudgetListItemView: View {

    let budget: Budget

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(budget.title ?? "").font(.title3)
                if let dateCreated = budget.dateCreated {
                    Text(
                        dateCreated,
                        format: .dateTime.day().month().year()
                    ).font(.caption)
                }
            }
            Spacer()
            Text(
                budget.amount,
                format: .currency(
                    code: Locale.current.currencyCode
                )
            )
        }
    }
}
