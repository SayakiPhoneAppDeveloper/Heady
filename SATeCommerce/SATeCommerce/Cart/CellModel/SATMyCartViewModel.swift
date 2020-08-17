//
//  SATMyCartViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATMyCartViewModel: NSObject {
    let productId: NSNumber!
    let variantId: NSNumber!
    var itemCount: NSNumber!
    
    init(productId: NSNumber, variantId: NSNumber, itemCount: NSNumber) {
        self.productId = productId
        self.variantId = variantId
        self.itemCount = itemCount
    }
    
    @discardableResult
    convenience init(from cart: SATMyCart){
        self.init(productId: NSNumber(value: cart.productId), variantId: NSNumber(value: cart.variantId), itemCount: NSNumber(value: cart.itemCount))
    }
}
