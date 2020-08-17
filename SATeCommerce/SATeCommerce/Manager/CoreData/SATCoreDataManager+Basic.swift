//
//  SATCoreDataManager+Basic.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
import CoreData

extension SATCoreDataManager {
    func fetchManageObjectForEnity(enityName : String, predicate : NSPredicate?, _ descriptorArray : [NSSortDescriptor]? = nil, context : NSManagedObjectContext) -> NSArray?{
                
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: enityName as String, in: context)!
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: enityName as String)
        fetchRequest.entity = entity
        if let predicate = predicate{
            fetchRequest.predicate = predicate
        }
        if let sortDescriptors = descriptorArray {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        var result:Any? =  nil
        do {
            result = try context.fetch(fetchRequest)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            
        }
        return result as? NSArray
        
    }
    
    func fetchManageObjectCountForEnity(enityName : String, predicate : NSPredicate, _ descriptorArray : [NSSortDescriptor]? = nil, context : NSManagedObjectContext) -> Int{
                
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: enityName as String, in: context)!
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: enityName as String)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        if let sortDescriptors = descriptorArray {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        var result: Int = 0
        do {
            result = try context.count(for: fetchRequest)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            
        }
        return result
        
    }
}
