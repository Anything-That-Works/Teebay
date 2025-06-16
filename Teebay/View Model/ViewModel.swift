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
    @Published var isDeleting: Bool = false

    func getProducts() {
        print(#function)
        Task {
            do {
                let products = try await APIServices.getProducts()
                await MainActor.run {
                    withAnimation {
                        self.products = products
                    }
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

    func updateProduct(using data: Product) {
        print(#function)
        Task {
            do {
                let products = try await APIServices.updateProduct(product: data)
                dump(products)
                await MainActor.run {
                    withAnimation {
                        self.getProducts()
                    }
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

    func deleteProduct(at offsets: IndexSet) {
        print(#function)
        Task {
            await MainActor.run {
                isDeleting = true
            }
            
            do {
                // Delete products sequentially to maintain order
                for index in offsets {
                    let product = products[index]
                    try await APIServices.deleteProduct(id: product.id)
                }
                
                // Update local state after successful deletion
                await MainActor.run {
                    products.remove(atOffsets: offsets)
                    isDeleting = false
                }
            } catch let appError as AppError {
                await MainActor.run {
                    processError = appError
                    showErrorAlert = true
                    isDeleting = false
                }
            } catch {
                await MainActor.run {
                    processError = AppError.serverError()
                    showErrorAlert = true
                    isDeleting = false
                }
            }
        }
    }


}
