//
//  SATSizeCollectionCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATSizeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var sizeLbl: UILabel!
    
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10.0
        container.layer.cornerRadius = 5.0
        selectionImageView.image = nil
    }
    
    func populateSize(size: String) -> Void {
        sizeLbl.text = size
    }
    
    func shouldSelect(isSelected: Bool) -> Void {
        selectionImageView.image = isSelected ? UIImage(named: "tick")?.coloredImage(color: .black) : nil
    }

}
