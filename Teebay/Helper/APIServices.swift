//
//  APIServices.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

class APIServices {
    public var shared: APIServices = APIServices()

    static func register(using data: RegistrationFormData) async throws -> User {
        let payload: [String: Any] = [
            "email": data.email,
            "password": data.password,
            "first_name": data.firstName,
            "last_name": data.lastName,
            "address": data.address,
            "firebase_console_manager_token": Constants.firebaseToken
        ]

        guard let url = URL(string: Constants.baseURL + Constants.registerEndpoint) else {
            print("Invalid URL: \(Constants.baseURL + Constants.registerEndpoint)")
            throw AppError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let data = try await Self.makeAPIRequest(using: request)

        guard let user = User.decode(from: data) else {
            throw AppError.decodingFailed
        }

        return user
    }

    static func login(email: String, password: String) async throws -> User {
        let payload = [
            "email": email,
            "password": password
        ]

        let url = URL(string: Constants.baseURL + Constants.loginEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let data = try await Self.makeAPIRequest(using: request)

        guard let authResponse = AuthResponse.decode(from: data) else {
            throw AppError.decodingFailed
        }
        return authResponse.user
    }

    private static func makeAPIRequest(using request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            return data
        } else {
            throw AppError.serverError(code: httpResponse.statusCode)
        }
    }
}
