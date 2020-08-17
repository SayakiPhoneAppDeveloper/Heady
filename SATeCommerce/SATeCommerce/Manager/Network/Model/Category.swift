//
//  Category.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
struct Category: Codable {
    let id: Int64
    let name: String?
    let products: [Product]?
    let child_categories: [Int64]?
}
