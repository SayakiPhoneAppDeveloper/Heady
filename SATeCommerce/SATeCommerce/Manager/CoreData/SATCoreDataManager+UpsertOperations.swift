//
//  SATCoreDataManager+Operations.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
import CoreData

extension SATCoreDataManager{
    
    func upsertSyncData(_ syncData: Response?, completion: @escaping (Bool)->()) -> Void {
        guard let categories = syncData?.categories, categories.count>0 else {
            completion(false)
            return
        }
        let context = self.backgroundContext
        context.perform {
            
            for category in categories {
                self.upsertCategory(category, context: context)
            }
            
            for ranking in syncData?.rankings ?? []{
                if let productRankings = ranking.products, productRankings.count>0 {
                    for productRanking in productRankings {
                        switch productRanking {
                        case is ViewRanking :
                            self.updateViewCount(productRanking as! ViewRanking, context: context)
                        case is OrderRanking :
                            self.updateOrderCount(productRanking as! OrderRanking, context: context)
                        case is ShareRanking :
                            self.updateShareCount(productRanking as! ShareRanking, context: context)
                        default: break
                            
                        }
                            
                    }
                }
            }

            do {
                try context.save()
                completion(true)
            } catch let error {
                print("Failed to upsert: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func upsertChildCategoryId(categoryId: Int64, parentCategory: SATCategory, context: NSManagedObjectContext) -> Void {
        var currentCategory: SATCategory
        let categoryPredicate: NSPredicate = NSPredicate(format: "categoryId = %@", NSNumber(value: categoryId))
        if let categories : [SATCategory] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: categoryEntity, predicate: categoryPredicate, context: context) as? [SATCategory], categories.count>0, let satCategory = categories.first {
            currentCategory = satCategory
        }else{
            currentCategory = SATCategory(context: context)
            currentCategory.categoryId = categoryId
        }
        currentCategory.parentCategory = parentCategory
        parentCategory.addToSubCategories(currentCategory)
    }
    
    func upsertCategory(_ category: Category, context: NSManagedObjectContext) -> Void {
        var currentCategory: SATCategory
        let categoryPredicate: NSPredicate = NSPredicate(format: "categoryId = %@", NSNumber(value: category.id))
        if let categories : [SATCategory] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: categoryEntity, predicate: categoryPredicate, context: context) as? [SATCategory], categories.count>0, let satCategory = categories.first {
            currentCategory = satCategory
        }else{
            currentCategory = SATCategory(context: context)
            currentCategory.categoryId = category.id
        }
        
        currentCategory.name = category.name
        for product in category.products ?? []{
            upsertProduct(product: product, satCategory: currentCategory, context: context)
        }
        for categoryId in category.child_categories ?? [] {
            upsertChildCategoryId(categoryId: categoryId, parentCategory: currentCategory, context: context)
        }
    }
    
    func upsertProduct(product: Product, satCategory: SATCategory, context: NSManagedObjectContext) -> Void {
        var currentProduct: SATProduct
        let productPredicate: NSPredicate = NSPredicate(format: "productId = %@", NSNumber(value: product.id))
        if let products : [SATProduct] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: productEntity, predicate: productPredicate, context: context) as? [SATProduct], products.count>0, let satProduct = products.first {
            currentProduct = satProduct
        }else{
            currentProduct = SATProduct(context: context)
            currentProduct.productId = product.id
        }
        currentProduct.name = product.name
//        let dateFormatter = DateFormatter()
////        2016-11-05T11:16:11.000Z
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)

        currentProduct.dateAdded = product.date_added
        //dateFormatter.date(from: product.date_added ?? "")
        
        for variant in product.variants ?? [] {
            upsertVariant(variant: variant, satProduct: currentProduct, context: context)
        }
        
        if let tax = product.tax, (tax.name ?? "").count>0 {
            upsertTax(tax: tax, satProduct: currentProduct, context: context)
        }
        
        currentProduct.category = satCategory
    }
    
    func upsertVariant(variant: Variant, satProduct: SATProduct, context: NSManagedObjectContext) -> Void {
        var currentVariant: SATVariant
        let variantPredicate: NSPredicate = NSPredicate(format: "variantId = %@", NSNumber(value: variant.id))
        if let variants : [SATVariant] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: variantEntity, predicate: variantPredicate, context: context) as? [SATVariant], variants.count>0, let satVariant = variants.first {
            currentVariant = satVariant
        }else{
            currentVariant = SATVariant(context: context)
            currentVariant.variantId = variant.id
        }
        currentVariant.color = variant.color
        currentVariant.size = variant.size ?? 0.0
        currentVariant.price = variant.price
        currentVariant.product = satProduct
    }
    
    func upsertTax(tax: Tax, satProduct: SATProduct, context: NSManagedObjectContext) -> Void {
        let currentTax: SATTax = SATTax(context: context)
        currentTax.name = tax.name
        currentTax.value = tax.value
        currentTax.product = satProduct
    }
    
    func updateViewCount(_ ranking: ViewRanking, context: NSManagedObjectContext) -> Void {
        var currentProduct: SATProduct
        let productPredicate: NSPredicate = NSPredicate(format: "productId = %@", NSNumber(value: ranking.id))
        if let products : [SATProduct] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: productEntity, predicate: productPredicate, context: context) as? [SATProduct], products.count>0, let satProduct = products.first {
            currentProduct = satProduct
            currentProduct.viewCount = ranking.view_count
        }
    }
    
    func updateOrderCount(_ ranking: OrderRanking, context: NSManagedObjectContext) -> Void {
        var currentProduct: SATProduct
        let productPredicate: NSPredicate = NSPredicate(format: "productId = %@", NSNumber(value: ranking.id))
        if let products : [SATProduct] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: productEntity, predicate: productPredicate, context: context) as? [SATProduct], products.count>0, let satProduct = products.first {
            currentProduct = satProduct
            currentProduct.orderCount = ranking.order_count
        }
    }
    
    func updateShareCount(_ ranking: ShareRanking, context: NSManagedObjectContext) -> Void {
        var currentProduct: SATProduct
        let productPredicate: NSPredicate = NSPredicate(format: "productId = %@", NSNumber(value: ranking.id))
        if let products : [SATProduct] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: productEntity, predicate: productPredicate, context: context) as? [SATProduct], products.count>0, let satProduct = products.first {
            currentProduct = satProduct
            currentProduct.shareCount = ranking.shares
        }
    }
    
    func upsertMyCart(productId: NSNumber, variantId: NSNumber, itemCount: NSNumber, completion: @escaping (Bool)->()){
        let context = self.backgroundContext
        context.perform {
            var currentCart: SATMyCart
            let productPredicate: NSPredicate = NSPredicate(format: "productId = %@ AND variantId = %@", productId, variantId)
            if let myCarts : [SATMyCart] = SATCoreDataManager.shared.fetchManageObjectForEnity(enityName: myCartEntity, predicate: productPredicate, context: context) as? [SATMyCart], myCarts.count>0, let satCart = myCarts.first {
                currentCart = satCart
                if itemCount.int16Value>0 {
                    currentCart.itemCount = itemCount.int16Value
                }else{
                    context.delete(currentCart)
                }
            }else{
                currentCart = SATMyCart(context: context)
                currentCart.productId = Int64(truncating: productId)
                currentCart.variantId = Int64(truncating: variantId)
                currentCart.itemCount = Int16(truncating: itemCount)
            }
            do {
                try context.save()
                completion(true)
            } catch let error {
                print("Failed to upsert: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
