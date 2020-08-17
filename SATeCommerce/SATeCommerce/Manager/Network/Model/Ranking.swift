//
//  Ranking.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation

class Ranking: Codable {
    let ranking: String = ""
    var products: [ProductRanking]?
    
    private enum CodingKeys: String, CodingKey {
        case ranking
        case products
    }
    
    enum RankingTypeKey: CodingKey {
        case ranking
    }
    
    enum RankingTypes: String, Decodable {
        case mostViewed = "Most Viewed Products"
        case mostOrdered = "Most OrdeRed Products"
        case mostShared = "Most ShaRed Products"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var rankingProductArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.products)
        let type = try container.decode(RankingTypes.self, forKey: CodingKeys.ranking)
        
        products = []
        
        while(!rankingProductArrayForType.isAtEnd)
        {
            switch type {
            case .mostViewed:
                print("most viewed")
                products?.append(try rankingProductArrayForType.decode(ViewRanking.self))
            case .mostShared:
                print("most shared")
                products?.append(try rankingProductArrayForType.decode(ShareRanking.self))
            case .mostOrdered:
                print("most ordered")
                products?.append(try rankingProductArrayForType.decode(OrderRanking.self))
            }
        }
    }
}
