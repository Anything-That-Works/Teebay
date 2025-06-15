//
//  Product+Codable.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

extension Product {
    static func decode(from jsonData: Data) -> Product? {
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
            return try decoder.decode(Product.self, from: jsonData)
        } catch {
            print("Failed to decode Product: \(error)")
            return nil
        }
    }

    static func decodeArray(from jsonData: Data) -> [Product]? {
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
            return try decoder.decode([Product].self, from: jsonData)
        } catch {
            print("Failed to decode Product array: \(error)")
            return nil
        }
    }

    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            return try encoder.encode(self)
        } catch {
            print("Failed to encode Product: \(error)")
            return nil
        }
    }
}
