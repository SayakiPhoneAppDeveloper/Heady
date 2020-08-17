//
//  ProductRanking.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation

class ProductRanking: Codable {
    let id: Int64
}

class ViewRanking: ProductRanking {
    var view_count: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case view_count
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.view_count = try container.decode(Int64.self, forKey: .view_count)
        try super.init(from: decoder)
    }
}

class OrderRanking: ProductRanking {
    var order_count: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case order_count
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.order_count = try container.decode(Int64.self, forKey: .order_count)
        try super.init(from: decoder)
    }
}

class ShareRanking: ProductRanking {
    var shares: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case shares
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shares = try container.decode(Int64.self, forKey: .shares)
        try super.init(from: decoder)
    }
}
