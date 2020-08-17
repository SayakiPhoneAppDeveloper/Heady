//
//  SATPriceCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol PriceCellDelegate: class {
    func addedInCart(count: Int)
}

class SATPriceCell: UITableViewCell {
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var addToCartLbl: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var notAvailableLbl: UILabel!
    
    @IBOutlet weak var repeatCountLbl: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func addCartAction(_ sender: Any) {
        if Int(stepper.value)>0{
            cartImageView.image = UIImage(named: "cart")?.coloredImage(color: .green)
            addToCartLbl.text = "Added in cart"
            stepper.alpha = 0.3
            stepper.isUserInteractionEnabled = false
            delegate?.addedInCart(count: Int(stepper.value))
            addCartBtn.isUserInteractionEnabled = false
        }
    }
    @IBAction func stepperAction(_ sender: Any) {
        let stepperMapping: [UIStepper: UILabel] = [stepper: repeatCountLbl]

        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notAvailableLbl.isHidden = true
        addCartBtn.layer.cornerRadius = 5.0
    }
    
    weak var delegate: PriceCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPrice(price: Float?, tax: SATTaxViewModel?) -> Void {
        if let price = price, price>0.0 {
            notAvailableLbl.isHidden = true
            priceLbl.text = "Price: \u{20B9}\(String(format: "%.2f", price))"
            if let tax = tax{
                taxLbl.text = tax.dataToShow ?? ""
            }
            repeatCountLbl.text = "0"
            stepper.value = 0
            cartImageView.image = UIImage(named: "cart")?.coloredImage(color: .black)
            addToCartLbl.text = "Add to cart"
            addCartBtn.isUserInteractionEnabled = true
            stepper.alpha = 1.0
            stepper.isUserInteractionEnabled = true
        }else{
            notAvailableLbl.isHidden = false
        }
    }
    
}
