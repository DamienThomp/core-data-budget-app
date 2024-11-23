//
//  BackgroundGradientView.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-19.
//

import SwiftUI

struct BackgroundGradientView: View {

    @State var isAnimating = false

    let colors: [Color]

    var body: some View {

        ZStack {
            if #available(iOS 18.0, *) {
                    MeshGradient(width: 3, height: 3, points: [
                        [0.0, 0.0], [isAnimating ? 0.75 : 0.25, 0.0], [1.0, 0.0],
                        [0.0, 0.7], [isAnimating ? 0.55 : 0.45, isAnimating ? 0.6 : 0.3], [1.0, 0.7],
                        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                    ], colors: colors, smoothsColors: true)
            } else {

                LinearGradient(
                    colors: [colors[0], .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .onAppear() {
            withAnimation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }

    }
}

#Preview {
    var backgroundColors: [Color] {
        [.pink, .magenta, .pink, .magenta, .white, .magenta, .black]
    }
    BackgroundGradientView(colors: backgroundColors)
}
