//
//  SATProductViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATProductViewModel: SATTitleImageViewModel {
    var subTitle1: String?
    var subTitle2: String?
    var mostCount: Int64 = 0
    var mode: CollectionMode?
    
    var variants: [SATVariantViewModel]?
    var tax: SATTaxViewModel?
        
    @discardableResult
    init(from product: SATProduct){
        super.init(id: product.productId, title: product.name, image: UIImage(named: "iphone"))
        if let satVariants = product.variants?.allObjects as? [SATVariant], satVariants.count>0 {
            variants = []
            for variant in satVariants {
                variants?.append(SATVariantViewModel(from: variant))
            }
        }
        if let satTax = product.tax{
            tax = SATTaxViewModel(from: satTax)
        }
    }
    
    @discardableResult
    init(from product: SATProduct, mode: CollectionMode){
        super.init(id: product.productId, title: product.name, image: UIImage(named: "product"))
        self.mode = mode
        switch mode {
            case .Categories, .AllProduct: 
                self.mostCount = -1
            case .MostViewedProduct:
                self.mostCount = Int64(product.viewCount)
            case .MostOrderedProduct:
                self.mostCount = Int64(product.orderCount)
            case .MostSharedProduct:
                self.mostCount = Int64(product.shareCount)
        }
        subTitle1 = ""
        subTitle2 = ""
        if let variants = product.variants?.allObjects as? [SATVariant] {
            if variants.count>1 {
                subTitle1 = "Available in \(variants.count) different style"
                let prices: [Float] = variants.map({ $0.price })
                if let lowest = prices.min(){
                    subTitle2 = "Starts at \u{20B9}\(String(describing: lowest))"
                }
            }else if variants.count == 1{
                if let variant = variants.first{
                    if let colr = variant.color {
                        subTitle1?.append("Color: \(colr)")
                    }
                    if variant.size>0 {
                        if subTitle1?.count ?? 0>0 {
                            subTitle1?.append(" | ")
                        }
                        subTitle1?.append("Size: \( variant.size)")
                    }
                    subTitle2?.append("Only @ \u{20B9}\(String(format: "%.2f", variant.price))")
                }
            }
        }
    }
}


