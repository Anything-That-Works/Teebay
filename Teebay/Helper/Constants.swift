//
//  Constants.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation
import UIKit

struct Constants {
    static let baseURL = "http://127.0.0.1:8000/api"
    static let registerEndpoint = "/users/register/"
    static let loginEndpoint = "/users/login/"
    static let firebaseToken = "dummy_firebase_token_for_testing"
    static let addProductEndpoint = "/products/"
    static let getProductsEndpoint = "/products/"
    static let deleteProductEndpoint = "/products/"
    static let updateProductEndpoint = "/products/"

    static let minVisibleWidth = 120.0
    static let mainviewOffset = UIScreen.main.bounds.width - minVisibleWidth
}
