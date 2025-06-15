//
//  RentOption.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

enum RentOption: String, Codable {
    case hour
    case day

    var label: String {
        switch self {
        case .hour:
            return "hourly"
        case .day:
            return "daily"
        }
    }
}
