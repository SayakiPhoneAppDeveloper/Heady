//
//  SATVariantViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATVariantViewModel {
    var variantId: Int64 = 0
    var colorStr: String?
    var size: Float?
    var price: Float?
    
    init(variantId: Int64?, colorStr: String?, size: Float?, price: Float?) {
        self.colorStr = colorStr
        self.size = size
        self.price = price
    }
    
    @discardableResult
    convenience init(from variant: SATVariant){
        self.init(variantId: variant.variantId, colorStr: variant.color, size: variant.size, price: variant.price)
    }
}
