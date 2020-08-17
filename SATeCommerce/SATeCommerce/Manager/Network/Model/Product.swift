//
//  Product.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
struct Product: Codable {
    let id: Int64
    let name: String?
    let date_added: Date?
    let variants: [Variant]?
    let tax: Tax?
}
