//
//  SATProductCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATProductCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var subLbl2: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var collectionModeImgVw: UIImageView!
    @IBOutlet weak var repeatCountLabel: UILabel!
    
    var productViewModel: SATProductViewModel!
    
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
    
    func setData(data: SATProductViewModel) -> Void {
        productViewModel = data
        if let image = data.image{
            self.productImageView.image = image
        }
        self.titleLbl.text = data.title ?? ""
        self.subLbl.text = data.subTitle1 ?? ""
        self.subLbl2.text = data.subTitle2 ?? ""
        self.repeatCountLabel.text = data.mostCount>0 ? ": \(data.mostCount)" : ""
        
        if let mode = data.mode{
            switch mode {
            
            case .Categories, .AllProduct:
                self.collectionModeImgVw.image = nil
                self.repeatCountLabel.text = ""
            case .MostViewedProduct:
                self.collectionModeImgVw.image = UIImage(named: "viewed")
            case .MostOrderedProduct:
                self.collectionModeImgVw.image = UIImage(named: "ordered")
            case .MostSharedProduct:
                self.collectionModeImgVw.image = UIImage(named: "shared")
            }
            
        }
    }
}
