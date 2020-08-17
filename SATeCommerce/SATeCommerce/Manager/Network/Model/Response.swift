//
//  Response.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation

struct Response: Codable {
    let categories: [Category]?
    let rankings: [Ranking]?
    
    private enum CodingKeys: String, CodingKey {
        case categories
        case rankings
    }
}
