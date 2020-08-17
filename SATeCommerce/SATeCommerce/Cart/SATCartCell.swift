//
//  SATCartCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol CartCellDelegate: class {
    func updateList()
}

class SATCartCell: UITableViewCell {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var variantLbl: UILabel!
    
    @IBOutlet weak var subTotalLbl: UILabel!
    
    @IBOutlet weak var repeatCountLbl: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperAction(_ sender: Any) {
        let stepperMapping: [UIStepper: UILabel] = [stepper: repeatCountLbl]

        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
        self.subTotalLbl.text = String(format: "\u{20B9} %.2f", priceRate*Float(stepper.value))
        cartItem.itemCount = NSNumber(value: stepper.value)
        SATCoreDataManager.shared.upsertMyCart(productId: cartItem.productId, variantId: cartItem.variantId, itemCount: NSNumber(value: Int(stepper.value))) { (_) in
            DispatchQueue.main.async {
                if Int(self.stepper.value) == 0{
                    self.delegate?.updateList()
                }
            }
        }
    }
    
    var cartItem: SATMyCartViewModel!
    
    var priceRate: Float = 0.0
    
    weak var delegate: CartCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCartItem(_ item: SATMyCartViewModel){
        cartItem = item
        repeatCountLbl.text = "\(cartItem.itemCount.intValue)"
        stepper.value = cartItem.itemCount.doubleValue
        SATCoreDataManager.shared.getProduct(productId: item.productId) { (product) in
            DispatchQueue.main.async {
                if let product = product{
                    self.productNameLbl.text = product.title
                    if let variants = product.variants, let variant = variants.first(where: { (v) -> Bool in
                        return v.variantId == item.variantId.int64Value
                    }){
                        var varTxt = ""
                        if let color = variant.colorStr, color.count>0 {
                            varTxt.append("Color: \(color)")
                        }
                        if let size = variant.size{
                            if varTxt.count>0{
                                varTxt.append(" | ")
                            }
                            varTxt.append(String(format: "Size: %.2f", size))
                        }
                        self.variantLbl.text = varTxt
                        if let price = variant.price{
                            self.priceRate = price
                            self.subTotalLbl.text = String(format: "\u{20B9} %.2f", price*self.cartItem.itemCount.floatValue)
                        }
                    }
                }
            }
        }
    }
    
}
