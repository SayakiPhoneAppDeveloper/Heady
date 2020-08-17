//
//  SATVariant+CoreDataProperties.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//
//

import Foundation
import CoreData


extension SATVariant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATVariant> {
        return NSFetchRequest<SATVariant>(entityName: "SATVariant")
    }

    @NSManaged public var variantId: Int64
    @NSManaged public var color: String?
    @NSManaged public var size: Float
    @NSManaged public var price: Float
    @NSManaged public var product: SATProduct?

}
