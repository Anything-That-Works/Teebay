//
//  ViewModel.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var products: [Product] = []
    @Published var processError: AppError?
    @Published var showErrorAlert: Bool = false
    @Published var isProcessingRequest: Bool = false
    @Published var isShowingMenu = false

    func getProducts() {
        print(#function)
        runAsyncWithErrorHandling {
            let products = try await APIServices.getProducts()
            await MainActor.run {
                withAnimation {
                    self.products = products
                    self.isProcessingRequest = false
                }
            }
        }
    }

    func updateProduct(using data: Product) {
        print(#function)
        isProcessingRequest = true
        runAsyncWithErrorHandling {
            let products = try await APIServices.updateProduct(product: data)
            print("Product Updated \(products.id)")
            withAnimation {
                self.getProducts()
            }
        }
    }

    func addNewProduct(_ product: Product) {
        print(#function)
        isProcessingRequest = true
        runAsyncWithErrorHandling {
            let product = try await APIServices.addNewProduct(product)
            print("\(product.title) added at \(product.id)")
            withAnimation {
                self.getProducts()
            }
        }
    }

    func delete(product: Product) {
        print(#function)
        isProcessingRequest = true
        runAsyncWithErrorHandling {
            try await APIServices.deleteProduct(id: product.id)
            withAnimation {
                self.getProducts()
            }
        }
    }

    func reset() {
        print(#function)
        withAnimation {
            user = nil
            products = []
            isShowingMenu = false
        }
        processError = nil
        showErrorAlert = false
        isProcessingRequest = false
    }

    func runAsyncWithErrorHandling(
        _ operation: @escaping () async throws -> Void
    ) {
        Task {
            do {
                try await operation()
            } catch let appError as AppError {
                await MainActor.run {
                    processError = appError
                    showErrorAlert = true
                }
            } catch {
                await MainActor.run {
                    processError = AppError.unknownError
                    showErrorAlert = true
                }
            }
        }
    }
}
