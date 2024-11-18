//
//  BudgetListItemView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import SwiftUI

struct BudgetListItem: View {

    let budget: Budget

    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(
                budget.amount,
                format: .currency(
                    code: Locale.current.currency?.identifier ?? "CAD"
                )
            )
        }
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    BudgetListItemView()
//}
