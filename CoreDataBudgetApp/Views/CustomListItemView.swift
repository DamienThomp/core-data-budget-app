//
//  CustomListItemView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import SwiftUI

struct CustomListIemView: View {
    
    let label: LocalizedStringKey
    let value: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value, format: .currency(
                code: Locale.current.currencyCode
            ))
        }
    }
}

#Preview("Default English") {
    CustomListIemView(label: "New Expense", value: 20)
}

#Preview("French") {
    CustomListIemView(label: "New Expense", value: 20)
        .environment(\.locale, .init(identifier: "fr_CA"))
}
