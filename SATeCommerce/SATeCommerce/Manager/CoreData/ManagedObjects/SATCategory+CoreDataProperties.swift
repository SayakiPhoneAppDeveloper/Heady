//
//  SATCategory+CoreDataProperties.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//
//

import Foundation
import CoreData


extension SATCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATCategory> {
        return NSFetchRequest<SATCategory>(entityName: "SATCategory")
    }

    @NSManaged public var categoryId: Int64
    @NSManaged public var name: String?
    @NSManaged public var subCategories: NSSet?
    @NSManaged public var parentCategory: SATCategory?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for subCategories
extension SATCategory {

    @objc(addSubCategoriesObject:)
    @NSManaged public func addToSubCategories(_ value: SATCategory)

    @objc(removeSubCategoriesObject:)
    @NSManaged public func removeFromSubCategories(_ value: SATCategory)

    @objc(addSubCategories:)
    @NSManaged public func addToSubCategories(_ values: NSSet)

    @objc(removeSubCategories:)
    @NSManaged public func removeFromSubCategories(_ values: NSSet)

}

// MARK: Generated accessors for products
extension SATCategory {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: SATProduct)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: SATProduct)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
