//
//  RoundedBorder.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

fileprivate struct RoundedBorder: ViewModifier {
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
