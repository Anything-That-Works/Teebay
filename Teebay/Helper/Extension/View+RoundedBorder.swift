//
//  RoundedBorder.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

private struct RoundedBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

extension View {
    func roundedBorder() -> some View {
        self.modifier(RoundedBorder())
    }
}

extension View {
    func getBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

// Add a new view modifier for injecting environment objects
extension View {
    func injectEnvironmentObjects(viewModel: ViewModel = ViewModel(), navigationHelper: NavigationHelper = NavigationHelper()) -> some View {
        self
            .environmentObject(viewModel)
            .environmentObject(navigationHelper)
    }
}
