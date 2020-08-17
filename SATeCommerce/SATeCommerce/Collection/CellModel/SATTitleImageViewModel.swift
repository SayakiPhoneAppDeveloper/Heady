//
//  SATTitleImageViewModel.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit
class SATTitleImageViewModel {
    var id: Int64 = 0
    var image: UIImage?
    var title: String?
    
    init(id: Int64, title: String?, image: UIImage?) {
        self.id = id
        self.title = title
        self.image = image
    }
}
