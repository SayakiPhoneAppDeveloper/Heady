//
//  Variant.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation

struct Variant: Codable {
    let id: Int64
    let color: String?
    let size: Float?
    let price: Float
    
}
