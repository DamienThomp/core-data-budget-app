//
//  CustomListItemView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import SwiftUI

struct CustomListIemView: View {

    let label: String
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

#Preview {
    CustomListIemView(label: "Some Label", value: 20)
}
