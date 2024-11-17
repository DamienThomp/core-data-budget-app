//
//  BudgetListScreen.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-16.
//

import SwiftUI

struct BudgetListScreen: View {

    @State private var isPresented: Bool = false

    var body: some View {
        List {
            Text("Budget Items will be listed here")
        }
        .navigationTitle("Budget App")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            Text("Add Budget Form")
        }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }
}
