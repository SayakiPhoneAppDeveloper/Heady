//
//  SATProduct+CoreDataProperties.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//
//

import Foundation
import CoreData


extension SATProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATProduct> {
        return NSFetchRequest<SATProduct>(entityName: "SATProduct")
    }

    @NSManaged public var productId: Int64
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var viewCount: Int64
    @NSManaged public var orderCount: Int64
    @NSManaged public var shareCount: Int64
    @NSManaged public var category: SATCategory?
    @NSManaged public var variants: NSSet?
    @NSManaged public var tax: SATTax?

}

// MARK: Generated accessors for variants
extension SATProduct {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: SATVariant)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: SATVariant)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
