//
//  SATCategoryViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATCategoryViewModel: SATTitleImageViewModel, Equatable {
    
    static func == (lhs: SATCategoryViewModel, rhs: SATCategoryViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    @discardableResult
    init(from category: SATCategory){
        super.init(id: category.categoryId, title: category.name, image: UIImage(named: "product"))
        
    }
}
