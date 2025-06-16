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
    case unknownError
    case serverError(code: HTTPURLResponse)
    case biometricNotAvailable
    case biometricAuthenticationFailed

    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown error."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "No response from server."
        case .decodingFailed:
            return "Unable to decode user data."
        case .encodingFailed:
            return "Unable to encode user data."
        case .biometricNotAvailable:
            return "Biometric authentication is not available on this device."
        case .biometricAuthenticationFailed:
            return "Biometric authentication failed. Please try again."
        case .serverError(let code):
            switch code.statusCode {
            case 400:
                return "user with this email already exists."
            case 401:
                return "Invalid email or password."
            case 404:
                return "No Product matches the given query."
            default:
                return "Unknown server error."
            }
        }
    }
}
