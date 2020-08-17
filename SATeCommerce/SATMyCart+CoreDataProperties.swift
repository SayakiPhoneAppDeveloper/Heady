//
//  SATMyCart+CoreDataProperties.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//
//

import Foundation
import CoreData


extension SATMyCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATMyCart> {
        return NSFetchRequest<SATMyCart>(entityName: "SATMyCart")
    }

    @NSManaged public var itemCount: Int16
    @NSManaged public var productId: Int64
    @NSManaged public var variantId: Int64

}
