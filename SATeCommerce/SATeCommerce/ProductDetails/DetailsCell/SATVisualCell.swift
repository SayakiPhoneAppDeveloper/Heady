//
//  SATVisualCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol VisualCellDelegate: class {
    func isAddedInWishlist(isAdded: Bool)
}

class SATVisualCell: UITableViewCell {
    @IBOutlet weak var wishButton: UIButton!
    @IBAction func wishAction(_ sender: Any) {
        if let btn: UIButton = sender as? UIButton{
            btn.isSelected = !btn.isSelected
            delegate?.isAddedInWishlist(isAdded: btn.isSelected)
        }
    }
    weak var delegate: VisualCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setWishlisted(isWished: Bool) -> Void {
        wishButton.isSelected = isWished
    }
    
}
