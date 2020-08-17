//
//  SATCoreDataManager+FetchOperation.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension SATCoreDataManager{
    func fetchCategories(predicate: NSPredicate, context: NSManagedObjectContext) -> [SATCategory]? {
        let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: categoryEntity,predicate: predicate, context: context)
        return resultArr as? [SATCategory]
    }
    
    func fetchParentCategories(completion: @escaping([SATCategoryViewModel]?)->()) {
        let context = backgroundContext
        context.perform {
            let categoryPredicate : NSPredicate = NSPredicate(format: "SUBQUERY(parentCategory, $x,($x.categoryId > %@)).@count == 0", NSNumber(value: 0))
            if let categories = self.fetchCategories(predicate: categoryPredicate, context: context), categories.count>0 {
                let categoryVMs = categories.compactMap({ (category) -> SATCategoryViewModel? in
                    return SATCategoryViewModel(from: category)
                })
                completion(categoryVMs)
            }else{
                completion(nil)
            }
        }
    }
    
    func fetchChildComponents(parentCategoryId: NSNumber, completion: @escaping (_ isCategory: Bool?, [SATTitleImageViewModel]?) -> ()) -> Void {
        let context = backgroundContext
        context.perform {
            let categoryPredicate : NSPredicate = NSPredicate(format: "categoryId = %@", parentCategoryId)
            if let categories = self.fetchCategories(predicate: categoryPredicate, context: context), categories.count>0, let category = categories.first {
                
                if let subCategories = category.subCategories?.allObjects as? [SATCategory], subCategories.count>0 {
                    let categoryVMs = subCategories.compactMap({ (subCategory) -> SATCategoryViewModel? in
                        return SATCategoryViewModel(from: subCategory)
                    })
                    completion(true, categoryVMs)
                }else if let products = category.products?.allObjects as? [SATProduct], products.count>0 {
                    let productVMs = products.compactMap({ (product) -> SATProductViewModel? in
                        return SATProductViewModel(from: product, mode: .AllProduct)
                    })
                    completion(false, productVMs)
                }else{
                    completion(nil, nil)
                }
            }else{
                completion(nil, nil)
            }
        }
    }
    
    fileprivate func fetchProducts(mode: CollectionMode, _ predicate: NSPredicate? = nil, _ sortDescriptors: [NSSortDescriptor]? = nil, _ context: NSManagedObjectContext? = nil) -> [SATProductViewModel]? {
        let moc: NSManagedObjectContext = context ??  mainContext
        
        let productsPredicate: NSPredicate =  predicate ?? NSPredicate(format: "productId > %@", NSNumber(value: 0))
        let productDescriptors: [NSSortDescriptor] = sortDescriptors ?? [NSSortDescriptor(key: "dateAdded", ascending: false)]
        let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: productEntity, predicate: productsPredicate, productDescriptors, context: moc)
        
        if let products = resultArr as? [SATProduct], products.count>0 {
            let productVMs = products.compactMap({ (product) -> SATProductViewModel? in
                return SATProductViewModel(from: product, mode: mode)
            })
            return productVMs
        }else{
            return nil
        }
    }
    
    fileprivate func fetchProducts(mode: CollectionMode, _ predicate: NSPredicate? = nil, _ context: NSManagedObjectContext? = nil) -> [SATProductViewModel]? {
        let moc: NSManagedObjectContext = context ??  mainContext
        
        let productsPredicate : NSPredicate = predicate ?? NSPredicate(format: "productId > %@", NSNumber(value: 0))
        let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: productEntity,predicate: productsPredicate, context: moc)
        
        if let products = resultArr as? [SATProduct], products.count>0 {
            let productVMs = products.compactMap({ (product) -> SATProductViewModel? in
                return SATProductViewModel(from: product, mode: mode)
            })
            return productVMs
        }else{
            return nil
        }
    }
    
    func searchProducts(mode: CollectionMode, searchKey: String?, _ sortDescriptor: NSSortDescriptor? = nil, completion: @escaping([SATProductViewModel]?)->()) {
        let context = backgroundContext
        context.perform {
            if let searchKey = searchKey, searchKey.count>0{
                let productSearchPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", "name", searchKey)
                completion(self.fetchProducts(mode: mode, productSearchPredicate, context))
            }else{
                completion(self.fetchProducts(mode: mode, nil,context))
            }
        }
    }
    
    func searchProductSortByMostViewed(mode: CollectionMode, searchKey: String?, completion: @escaping([SATProductViewModel]?)->()){
        let context = backgroundContext
        context.perform {
            let productDescriptor: NSSortDescriptor = NSSortDescriptor(key: "viewCount", ascending: false)
            if let searchKey = searchKey, searchKey.count>0{
                let productSearchPredicate = NSPredicate(format: "%K CONTAINS[cd] %@ AND viewCount > %@", "name", searchKey, NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productSearchPredicate, [productDescriptor], context))
            }else{
                let productViewPredicate = NSPredicate(format: "viewCount > %@", NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productViewPredicate, [productDescriptor] ,context))
            }
        }
    }
    
    func searchProductSortByMostOrdered(mode: CollectionMode, searchKey: String?, completion: @escaping([SATProductViewModel]?)->()){
        let context = backgroundContext
        context.perform {
            let productDescriptor: NSSortDescriptor = NSSortDescriptor(key: "orderCount", ascending: false)
            if let searchKey = searchKey, searchKey.count>0{
                let productSearchPredicate = NSPredicate(format: "%K CONTAINS[cd] %@ AND orderCount > %@", "name", searchKey, NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productSearchPredicate, [productDescriptor], context))
            }else{
                let productOrderPredicate = NSPredicate(format: "orderCount > %@", NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productOrderPredicate, [productDescriptor] ,context))
            }
        }
    }
    
    func searchProductSortByMostShared(mode: CollectionMode, searchKey: String?, completion: @escaping([SATProductViewModel]?)->()){
        let context = backgroundContext
        context.perform {
            let productDescriptor: NSSortDescriptor = NSSortDescriptor(key: "shareCount", ascending: false)
            if let searchKey = searchKey, searchKey.count>0{
                let productSearchPredicate = NSPredicate(format: "%K CONTAINS[cd] %@ AND shareCount > %@", "name", searchKey, NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productSearchPredicate, [productDescriptor], context))
            }else{
                let productSharePredicate = NSPredicate(format: "shareCount > %@", NSNumber(value: 0))
                completion(self.fetchProducts(mode: mode, productSharePredicate, [productDescriptor] ,context))
            }
        }
    }
    
    func fetchWishlist(completion: @escaping([SATProductViewModel]?)->()){
        let wishListIds = UserDefaults.standard.getWishlist()
        if  wishListIds.count>0 {
            let context = backgroundContext
            context.perform {
                let predicate = NSPredicate(format: "productId IN %@", wishListIds)
                completion(self.fetchProducts(mode: .AllProduct, predicate, context))
            }
        }else{
            completion(nil)
        }
    }
    
    func getProduct(productId: NSNumber, completion: @escaping(SATProductViewModel?)->()) -> Void {
        let context = backgroundContext
        context.perform {
            let productsPredicate : NSPredicate = NSPredicate(format: "productId = %@", productId)
            let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: productEntity,predicate: productsPredicate, context: context)
            
            if let products = resultArr as? [SATProduct], products.count>0, let product = products.first {
                completion(SATProductViewModel(from: product))
            }else{
                completion(nil)
            }
        }
    }
    
    func fetchMyCart(completion: @escaping([SATMyCartViewModel]?)->()){
        let context = backgroundContext
        context.perform {
            let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: myCartEntity,predicate: nil, context: context)
            
            if let myCarts = resultArr as? [SATMyCart], myCarts.count>0 {
                let cartsVMs = myCarts.compactMap({ (cart) -> SATMyCartViewModel? in
                    return SATMyCartViewModel(from: cart)
                })
                completion(cartsVMs)
            }else{
                completion(nil)
            }
        }
    }
    
    func fetchMyCart(productId: NSNumber, variantId: NSNumber, completion: @escaping(SATMyCartViewModel?)->()){
        let context = backgroundContext
        context.perform {
            let productPredicate: NSPredicate = NSPredicate(format: "productId = %@ AND variantId = %@", productId, variantId)
            let resultArr : NSArray? = self.fetchManageObjectForEnity(enityName: myCartEntity, predicate: productPredicate, context: context)
            
            if let myCarts = resultArr as? [SATMyCart], myCarts.count>0, let satCart = myCarts.first {
                completion(SATMyCartViewModel(from: satCart))
            }else{
                completion(nil)
            }
        }
    }
}
