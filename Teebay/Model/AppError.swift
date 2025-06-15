//
//  AppError.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

enum AppError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case encodingFailed
    case serverError(code: Int? = nil)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "No response from server."
        case .decodingFailed:
            return "Unable to decode user data."
        case .encodingFailed:
            return "Unable to encode user data."
        case .serverError(let code):
            switch code {
            case 401:
                return "Invalid email or password."
            case 400:
                return "user with this email already exists."
            default:
                return "Unknown server error."
            }
        }
    }
}
