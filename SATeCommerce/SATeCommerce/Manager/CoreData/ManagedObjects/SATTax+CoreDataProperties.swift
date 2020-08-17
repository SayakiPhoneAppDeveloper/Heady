//
//  SATTax+CoreDataProperties.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//
//

import Foundation
import CoreData


extension SATTax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATTax> {
        return NSFetchRequest<SATTax>(entityName: "SATTax")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Float
    @NSManaged public var product: SATProduct?

}
