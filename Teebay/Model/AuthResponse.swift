//
//  AuthResponse.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

struct AuthResponse: Decodable {
    let message: String
    let user: User
}

extension AuthResponse {
    static func decode(from jsonData: Data) -> AuthResponse? {
        let decoder = JSONDecoder()

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds,
        ]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
            return date
        }

        do {
            let model = try decoder.decode(AuthResponse.self, from: jsonData)
            return model
        } catch {
            print("Failed to decode AuthResponse: \(error)")
            return nil
        }
    }
}
