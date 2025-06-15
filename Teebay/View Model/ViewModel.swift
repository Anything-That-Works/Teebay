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

    func getUsersProduct(){
        products = Product.previewData
    }
}
