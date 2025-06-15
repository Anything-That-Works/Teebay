//
//  TeebayApp.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

@main
struct TeebayApp: App {
    @StateObject private var viewModel: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .environmentObject(viewModel)
        }
    }
}
