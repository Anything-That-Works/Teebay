//
//  APIServices.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

class APIServices {
    public var shared: APIServices = APIServices()

    static func register(using data: RegistrationFormData) async throws -> User
    {
        let payload: [String: Any] = [
            "email": data.email,
            "password": data.password,
            "first_name": data.firstName,
            "last_name": data.lastName,
            "address": data.address,
            "firebase_console_manager_token": Constants.firebaseToken,
        ]

        guard
            let url = URL(
                string: Constants.baseURL + Constants.registerEndpoint
            )
        else {
            print(
                "Invalid URL: \(Constants.baseURL + Constants.registerEndpoint)"
            )
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let response = try await Self.makeAPIRequest(using: request)

        guard let user = User.decode(from: response.data) else {
            throw AppError.decodingFailed
        }

        return user
    }

    static func login(email: String, password: String) async throws -> User {
        let payload = [
            "email": email,
            "password": password,
        ]

        let url = URL(string: Constants.baseURL + Constants.loginEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let response = try await Self.makeAPIRequest(using: request)

        guard let authResponse = AuthResponse.decode(from: response.data) else {
            throw AppError.decodingFailed
        }
        return authResponse.user
    }

    static func addNewProduct(_ product: Product) async throws -> Product {
        guard
            let url = URL(
                string: Constants.baseURL + Constants.addProductEndpoint
            )
        else {
            print(
                "Invalid URL: \(Constants.baseURL + Constants.addProductEndpoint)"
            )
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = createMultipartBody(
            boundary: boundary,
            product: product
        )

        let response = try await Self.makeAPIRequest(using: request)

        guard let decodedProduct = Product.decode(from: response.data) else {
            throw AppError.decodingFailed
        }

        return decodedProduct
    }

    static func getProducts() async throws -> [Product] {
        guard
            let url = URL(
                string: Constants.baseURL + Constants.getProductsEndpoint
            )
        else {
            print(
                "Invalid URL: \(Constants.baseURL + Constants.getProductsEndpoint)"
            )
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let response = try await Self.makeAPIRequest(using: request)

        guard let products = Product.decodeArray(from: response.data) else {
            throw AppError.decodingFailed
        }

        return products
    }

    static func deleteProduct(id: Int) async throws {
        print(id)
        guard let url = URL(string: Constants.baseURL + Constants.deleteProductEndpoint + "\(id)/") else {
            print("Invalid URL: \(Constants.baseURL + Constants.deleteProductEndpoint)\(id)/")
            throw AppError.invalidURL
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let response = try await Self.makeAPIRequest(using: request)

        print(response.httpResponse)
    }

    static func updateProduct(product: Product) async throws -> Product {
        guard let url = URL(string: Constants.baseURL + Constants.updateProductEndpoint + "\(product.id)/") else {
            print("Invalid URL: \(Constants.baseURL + Constants.updateProductEndpoint)\(product.id)/")
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = createMultipartBody(boundary: boundary, product: product)

        let response = try await Self.makeAPIRequest(using: request)

        guard let updatedProduct = Product.decode(from: response.data) else {
            throw AppError.decodingFailed
        }

        return updatedProduct
    }

    private static func createMultipartBody(boundary: String, product: Product)
    -> Data
    {
        var body = Data()

        func appendField(name: String, value: String) {
            if let data = "--\(boundary)\r\n".data(using: .utf8) {
                body.append(data)
            }
            if let data =
                "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(
                    using: .utf8
                )
            {
                body.append(data)
            }
            if let data = "\(value)\r\n".data(using: .utf8) {
                body.append(data)
            }
        }

        func appendFile(
            name: String,
            filename: String,
            data: Data,
            mimeType: String
        ) {
            if let boundary = "--\(boundary)\r\n".data(using: .utf8) {
                body.append(boundary)
            }
            if let disposition =
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
                .data(using: .utf8)
            {
                body.append(disposition)
            }
            if let contentType = "Content-Type: \(mimeType)\r\n\r\n".data(
                using: .utf8
            ) {
                body.append(contentType)
            }
            body.append(data)
            if let newline = "\r\n".data(using: .utf8) { body.append(newline) }
        }

        appendField(name: "seller", value: "\(product.seller)")
        appendField(name: "title", value: product.title)
        appendField(name: "description", value: product.description)

        for category in product.categories {
            appendField(name: "categories", value: category.rawValue)
        }

        guard let imageData = Data(base64Encoded: product.productImage) else {
            print("data converstion failed")
            return Data()
        }
        appendFile(
            name: "product_image",
            filename: "image.png",
            data: imageData,
            mimeType: "image/png"
        )
        appendField(name: "purchase_price", value: "\(product.purchasePrice)")
        appendField(name: "rent_price", value: "\(product.rentPrice)")
        appendField(name: "rent_option", value: product.rentOption.rawValue)

        if let finalBoundary = "--\(boundary)--\r\n".data(using: .utf8) {
            body.append(finalBoundary)
        }

        return body
    }

    private static func makeAPIRequest(using request: URLRequest) async throws
    -> (data: Data, httpResponse: HTTPURLResponse)
    {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            return (data, httpResponse)
        } else {
            throw AppError.serverError(code: httpResponse.statusCode)
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
