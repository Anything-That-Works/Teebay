//
//  User.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let address: String
    let firebaseConsoleManagerToken: String
    let password: String
    let dateJoined: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case address
        case firebaseConsoleManagerToken = "firebase_console_manager_token"
        case password
        case dateJoined = "date_joined"
    }
}

// MARK: - Preview Data
extension User {
    static let previewData: [User] = [
        User(
            id: 2,
            email: "max@well.com",
            firstName: "Max",
            lastName: "Well",
            address: "Address of Max",
            firebaseConsoleManagerToken: "dummy_firebase_token_for_testing",
            password: "123123",
            dateJoined: ISO8601DateFormatter().date(from: "2025-06-10T23:57:48.171582Z") ?? Date()
        ),
        User(
            id: 1,
            email: "jane@example.com",
            firstName: "Jane",
            lastName: "Doe",
            address: "123 Main Street, Anytown, USA",
            firebaseConsoleManagerToken: "sample_token_123",
            password: "password123",
            dateJoined: Date().addingTimeInterval(-86400)
        ),
        User(
            id: 3,
            email: "john@test.org",
            firstName: "John",
            lastName: "Smith",
            address: "456 Oak Avenue, Some City, State",
            firebaseConsoleManagerToken: "test_token_456",
            password: "securepass",
            dateJoined: Date().addingTimeInterval(-172800)
        )
    ]

    static let sampleUser = previewData[0]
}
