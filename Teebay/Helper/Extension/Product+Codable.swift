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
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(Product.self, from: jsonData)
        } catch {
            print("Failed to decode Product: \(error)")
            return nil
        }
    }

    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .iso8601
        do {
            return try encoder.encode(self)
        } catch {
            print("Failed to encode Product: \(error)")
            return nil
        }
    }
}
