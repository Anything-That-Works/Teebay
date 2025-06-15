//
//  Category.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case electronics
    case furniture
    case homeAppliances = "home_appliances"
    case sportingGoods = "sporting_goods"
    case outdoor
    case toys

    var value: String {
        switch self {
        case .electronics: return "Electronics"
        case .furniture: return "Furniture"
        case .homeAppliances: return "Home Appliances"
        case .sportingGoods: return "Sporting Goods"
        case .outdoor: return "Outdoor"
        case .toys: return "Toys"
        }
    }
}
