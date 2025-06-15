//
//  ViewModel.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var products: [Product] = []
    @Published var processError: AppError?
    @Published var showErrorAlert: Bool = false

    func getProducts() {
        print(#function)
        Task {
            do {
                let products = try await APIServices.getProducts()

                await MainActor.run {
                    self.products = products
                }
            } catch let appError as AppError {
                await MainActor.run {
                    processError = appError
                    showErrorAlert = true
                }
            } catch {
                await MainActor.run {
                    processError = AppError.serverError()
                    showErrorAlert = true
                }
            }
        }
    }
}
