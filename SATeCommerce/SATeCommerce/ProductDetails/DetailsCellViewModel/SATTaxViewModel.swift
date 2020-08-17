//
//  SATTaxViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATTaxViewModel {
    var dataToShow: String?
    
    init(name: String?, value: Float) {
        self.dataToShow = "Including \(name ?? "tax"): \(value)"
        
    }
    
    @discardableResult
    convenience init(from tax: SATTax){
        self.init(name: tax.name, value: tax.value)
    }
}
