//
//  SATCategoryCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATCategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    var categoryViewModel: SATCategoryViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.25
    }
    
    func setData(data: SATCategoryViewModel) -> Void {
        categoryViewModel = data
        self.categoryImageView.image = data.image
        self.categoryTitleLbl.text = data.title
    }

}
