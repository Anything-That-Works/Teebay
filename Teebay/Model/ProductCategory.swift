//
//  ProductCategory.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation

enum Category: String, Codable {
    case electronics
    case furniture
    case homeAppliances = "home_appliances"
    case sportingGoods = "sporting_goods"
    case outdoor
    case toys
}
