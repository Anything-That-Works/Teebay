//
//  Product.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//
import Foundation

struct Product: Codable {
    var id: Int
    var seller: Int
    var title: String
    var description: String
    var categories: [Category]
    var productImage: Data
    var purchasePrice: Decimal
    var rentPrice: Decimal
    var rentOption: RentOption
    var datePosted: Date

    enum CodingKeys: String, CodingKey {
        case id
        case seller
        case title
        case description
        case categories
        case productImage = "product_image"
        case purchasePrice = "purchase_price"
        case rentPrice = "rent_price"
        case rentOption = "rent_option"
        case datePosted = "date_posted"
    }
}

extension Product {
    static func empty() -> Product {
//        previewData[0]
        Product(
            id: -1,
            seller: -1,
            title: "",
            description: "",
            categories: [],
            productImage: Data(),
            purchasePrice: 0,
            rentPrice: 0,
            rentOption: .day,
            datePosted: Date()
        )
    }
    
    static let previewData: [Product] = [
        Product(
            id: 0,
            seller: 1,
            title: "Gaming Laptop",
            description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porta ac neque ut aliquam. Aenean congue ipsum sit amet nisi luctus, ut mollis quam fringilla. Nunc blandit malesuada diam, et tristique nisi accumsan sit amet. In porttitor sodales justo. Curabitur mollis sed ex non efficitur. Praesent rutrum vel nunc ut sodales. Aliquam pharetra lacus sed diam porttitor, nec auctor lacus faucibus. Maecenas mollis sodales leo, vitae gravida turpis efficitur et. Quisque et libero ac erat malesuada euismod.

                Ut et eleifend eros. Nulla cursus lobortis luctus. Mauris mollis urna at diam tristique faucibus. Ut nibh risus, sagittis a sapien nec, auctor blandit dui. Suspendisse potenti. Vestibulum commodo rhoncus lacus, eget hendrerit odio molestie nec. In molestie vitae sapien in eleifend.

                Sed dapibus consectetur libero, mattis maximus enim elementum a. Morbi laoreet ultrices nibh, vitae iaculis elit. Ut id sapien a nisl sollicitudin consectetur. Quisque vulputate augue nec quam fermentum laoreet. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis viverra dolor a ipsum suscipit aliquet. Nunc vel augue in odio cursus congue nec at purus.

                Pellentesque cursus gravida facilisis. Nullam viverra pulvinar eros, at vulputate ante lacinia a. Nulla facilisi. Vestibulum elit ante, sagittis ut mollis at, efficitur a tellus. In nisi metus, finibus sit amet aliquam nec, condimentum sit amet elit. Morbi posuere lorem risus. Nullam semper faucibus mattis. Praesent id lacus a velit venenatis viverra. Vestibulum facilisis tellus ac mauris imperdiet iaculis. Fusce nec velit diam. Praesent fermentum, turpis at finibus ornare, eros lorem eleifend mauris, vitae pulvinar elit justo eu mauris.

                Etiam consequat velit nisl, non posuere orci ullamcorper sed. Nam ut luctus sem. Nulla risus justo, interdum sit amet tellus eget, gravida elementum mauris. Aenean elementum augue nec sollicitudin viverra. Nullam ac pharetra mauris. Etiam vel risus sodales, fermentum orci ut, porta odio. Phasellus ut maximus libero. Pellentesque efficitur lacus nec orci pulvinar eleifend nec sed felis. Sed mattis lectus elit, a rhoncus ipsum convallis quis. Vestibulum vitae mollis libero. Nunc efficitur efficitur elit ac porta. Morbi molestie tincidunt dui fermentum bibendum. Mauris vulputate, metus at pharetra rutrum, nulla lorem hendrerit diam, sed facilisis lorem ligula eget augue.
                """,
            categories: [.electronics],
            productImage: Data(base64Encoded: "bGFwdG9wX2ltYWdl") ?? Data(),
            purchasePrice: Decimal(string: "1500") ?? 0,
            rentPrice: Decimal(string: "50") ?? 0,
            rentOption: .day,
            datePosted: ISO8601DateFormatter().date(from: "2025-06-10T09:30:00Z") ?? Date()
        ),
        Product(
            id: 1,
            seller: 3,
            title: "Mountain Bike",
            description: "Durable bike for outdoor adventures",
            categories: [.outdoor, .sportingGoods],
            productImage: Data(base64Encoded: "bW91bnRhaW5fYmlrZV9pbWFnZQ==") ?? Data(),
            purchasePrice: Decimal(string: "850") ?? 0,
            rentPrice: Decimal(string: "25") ?? 0,
            rentOption: .day,
            datePosted: ISO8601DateFormatter().date(from: "2025-05-20T14:45:00Z") ?? Date()
        ),
        Product(
            id: 2,
            seller: 2,
            title: "Office Desk",
            description: "Spacious wooden desk with drawers",
            categories: [.furniture],
            productImage: Data(base64Encoded: "b2ZmaWNlX2Rlc2tfaW1hZ2U=") ?? Data(),
            purchasePrice: Decimal(string: "300") ?? 0,
            rentPrice: Decimal(string: "15") ?? 0,
            rentOption: .hour,
            datePosted: ISO8601DateFormatter().date(from: "2025-06-01T08:00:00Z") ?? Date()
        )
    ]

    static let sampleProduct = previewData[0]
}


