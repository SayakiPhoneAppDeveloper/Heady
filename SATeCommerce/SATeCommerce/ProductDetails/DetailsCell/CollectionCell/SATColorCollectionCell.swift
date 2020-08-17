//
//  SATColorCollectionCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATColorCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var imageViewSelection: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor(colorName: "Black")?.cgColor
        self.layer.borderWidth = 1.0
        
        viewColor.layer.cornerRadius = 5.0
        viewColor.layer.borderColor = UIColor(colorName: "Black")?.cgColor
        viewColor.layer.borderWidth = 0.5
        imageViewSelection.image = nil
    }
    func populateColor(color: UIColor) -> Void {
        viewColor.backgroundColor = color
        self.backgroundColor = color.withAlphaComponent(0.3)
    }
    
    func shouldSelect(isSelected: Bool) -> Void {
        imageViewSelection.image = isSelected ? UIImage(named: "tick")?.coloredImage(color: (viewColor.backgroundColor?.cgColor == UIColor(colorName: "White")?.cgColor ? .black : .white)) : nil
    }
    
}
