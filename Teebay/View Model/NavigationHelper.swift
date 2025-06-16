//
//  NavigationManager.swift
//  Teebay
//
//  Created by Promal on 16/6/25.
//

import Foundation
import SwiftUI

// MARK: - Route Types
enum AppRoute: Hashable {
    case loginView
    case registrationView
    case addProductView
    case editProductView(product: Product)
    case myProductsView
    case allProductView
    case dummyRoute // Added for preview support
}

// MARK: - Navigation Helper
class NavigationHelper: ObservableObject {
    @Published var path = NavigationPath()

    func popToRoot() {
        path = NavigationPath()
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func push<V: Hashable>(_ value: V) {
        path.append(value)
    }
}
