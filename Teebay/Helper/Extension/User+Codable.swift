//
//  User+Codable.swift
//  teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

extension User {
    static func decode(from jsonData: Data) -> User? {
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
            let model = try decoder.decode(User.self, from: jsonData)
            return model
        } catch {
            print("Failed to decode User: \(error)")
            return nil
        }
    }

    func encode() -> Data? {
        let encoder = JSONEncoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds,
        ]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = formatter.string(from: date)
            try container.encode(dateString)
        }
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        } catch {
            print("Failed to encode User: \(error)")
            return nil
        }
    }
}
