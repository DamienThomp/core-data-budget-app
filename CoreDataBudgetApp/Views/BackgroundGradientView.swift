//
//  BackgroundGradientView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-19.
//

import SwiftUI

struct BackgroundGradientView: View {

    let colors: [Color]

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundGradientView(colors: [.teal, .black])
}
