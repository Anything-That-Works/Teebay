//
//  TeebayApp.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

@main
struct TeebayApp: App {
    @StateObject private var viewModel = ViewModel()
    @StateObject private var navigationHelper = NavigationHelper()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationHelper.path) {
                LoginView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .loginView:
                            LoginView()
                                .navigationBarBackButtonHidden()
                        case .registrationView:
                            RegistrationView()
                                .navigationBarBackButtonHidden()
                        case .addProductView:
                            AddProductView()
                        case .editProductView(let product):
                            EditProductView(product: product)
                        case .myProductsView:
                            MyProductsView()
                                .navigationBarBackButtonHidden()
                        case .allProductView:
                            AllProductsView()
                                .navigationBarBackButtonHidden()
                        case .dummyRoute:
                            Text("This Route should only be used for testing")
                        }
                    }
            }
            .environmentObject(viewModel)
            .environmentObject(navigationHelper)
        }
    }
}
