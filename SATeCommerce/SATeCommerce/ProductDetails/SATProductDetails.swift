//
//  SATProductDetails.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

enum CellType {
    case ProductImage
    case ProductColor
    case ProductSize
    case ProductPrice
}

protocol SATProductDetailsDelegate: class {
    func updateList()
}

class SATProductDetails: UITableViewController {
    
    private var product: SATProductViewModel!
    
    private var colorSet: Array<String> = []
    private var sizeSet: Array<Float> = []
    
    private var cellTypeArray: Array<CellType> = []
    
    private var selectedColor: String?
    private var selectedSize: Float?
    private var selectedVariantId: NSNumber!
    
    weak var delegate: SATProductDetailsDelegate?
    
    
    let visualCellReuseIdentifier = "SATVisualCell"
    let colorCellReuseIdentifier = "SATColorCell"
    let sizeCellReuseIdentifier = "SATSizeCell"
    let priceCellReuseIdentifier = "SATPriceCell"
    let cartCellReuseIdentifier = "SATCartCell"
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func refreshPrice(){
        if let index = cellTypeArray.firstIndex(of: .ProductPrice){
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
            with: .fade)
        }
    }
    
    func getPrice(size: Float?, color: String?)->Float {
        return getVariant(size: size ?? 0.0, color: color)?.price ?? 0.0
    }
    
    func getVariantId(size: Float?, color: String?) -> NSNumber{
        return NSNumber(value:getVariant(size: size ?? 0.0, color: color)?.variantId ?? 0)
    }
    
    func getVariant(size: Float, color: String?)->SATVariantViewModel? {
        var variant: SATVariantViewModel?
        if let variants = product?.variants, variants.count>0 {
            let choosenVariant = variants.filter({ (variant) -> Bool in
                return variant.colorStr == color && variant.size == size
            })
            if choosenVariant.count>0 {
                variant = choosenVariant.first
            }
        }
        return variant
    }
    
    
    func setProduct(productId: NSNumber) -> Void {
        SATCoreDataManager.shared.getProduct(productId: productId) { (product) in
            self.product = product
            self.cellTypeArray.append(.ProductImage)
            if let variants = product?.variants, variants.count>0 {
                var colorStrArr: [String] = []
                var sizeArr: [Float] = []
                for variant in variants {
                    if let colorStr = variant.colorStr, colorStr.count>0{
                        colorStrArr.append(colorStr)
                    }
                    if let size = variant.size, size>0 {
                        sizeArr.append(size)
                    }
                }
                self.colorSet = Array(Set(colorStrArr))
                if self.colorSet.count>0{
                    self.selectedColor = self.colorSet[0]
                    self.cellTypeArray.append(.ProductColor)
                }
                self.sizeSet = Array(Set(sizeArr))
                if self.sizeSet.count>0{
                    self.selectedSize = self.sizeSet[0]
                    self.cellTypeArray.append(.ProductSize)
                }
                
                self.cellTypeArray.append(.ProductPrice)
            }
            DispatchQueue.main.async {
                self.setupNavigationBar(title: self.product?.title ?? "Product")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.cellTypeArray[indexPath.row]
        switch type {
        case .ProductImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: visualCellReuseIdentifier, for: indexPath) as! SATVisualCell
            let wishList = UserDefaults.standard.getWishlist()
            if wishList.contains(NSNumber(value: self.product.id)){
                cell.setWishlisted(isWished: true)
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .ProductColor:
            let cell = tableView.dequeueReusableCell(withIdentifier: colorCellReuseIdentifier, for: indexPath) as! SATColorCell
            cell.delegate = self
            cell.selectedItem = self.selectedColor
            cell.selectionItems = colorSet
            cell.selectionStyle = .none
            return cell
        case .ProductSize:
            let cell = tableView.dequeueReusableCell(withIdentifier: sizeCellReuseIdentifier, for: indexPath) as! SATSizeCell
            cell.delegate = self
            cell.selectedItem = self.selectedSize
            cell.selectionItems = sizeSet
            cell.selectionStyle = .none
            return cell
        case .ProductPrice:
            let cell = tableView.dequeueReusableCell(withIdentifier: priceCellReuseIdentifier, for: indexPath) as! SATPriceCell
            cell.selectionStyle = .none
            cell.delegate = self
            let calculatedPrice = getPrice(size: selectedSize, color: selectedColor)
            self.selectedVariantId = self.getVariantId(size: self.selectedSize, color: self.selectedColor)
            cell.setPrice(price: calculatedPrice, tax: product?.tax)
            return cell
        }
    }
}

extension SATProductDetails: ColorSelectionTableCellDelegate, SizeSelectionTableCellDelegate, VisualCellDelegate, PriceCellDelegate {
    func isAddedInWishlist(isAdded: Bool) {
        if isAdded {
            UserDefaults.standard.addProductToWishlist(NSNumber(value: self.product.id))
        }else{
            UserDefaults.standard.removeProductFromWishlist(NSNumber(value: self.product.id))
        }
    }
    
    func sizeSelected(_ size: Float?) {
        selectedSize = size
        refreshPrice()
    }
    
    func colorSelected(_ color: String?) {
        selectedColor = color
        refreshPrice()
    }
    
    func addedInCart(count: Int) {
        SATCoreDataManager.shared.upsertMyCart(productId: NSNumber(value: product.id), variantId: selectedVariantId, itemCount: NSNumber(value: count)) { (_) in
            
        }
    }
}

//MARK:- Table setup
extension SATProductDetails {
    
    func setupTableView() -> Void {
        tableView.register(UINib(nibName: "SATVisualCell", bundle: nil), forCellReuseIdentifier: visualCellReuseIdentifier)
        tableView.register(UINib(nibName: "SATColorCell", bundle: nil), forCellReuseIdentifier: colorCellReuseIdentifier)
        tableView.register(UINib(nibName: "SATSizeCell", bundle: nil), forCellReuseIdentifier: sizeCellReuseIdentifier)
        tableView.register(UINib(nibName: "SATPriceCell", bundle: nil), forCellReuseIdentifier: priceCellReuseIdentifier)
        tableView.register(UINib(nibName: "SATCartCell", bundle: nil), forCellReuseIdentifier: cartCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.hidingEmptyTableViewRows()
    }
    
    func hidingEmptyTableViewRows(){
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

//MARK:- Navigation setup
extension SATProductDetails {
    func setupNavigationBar(title: String) -> Void {
           self.clearNavigationBarItems()
           self.setNavigationBarColor(.red)
           self.setNavigationBarTintColor(.white)
           
           if let backImage = UIImage(named: "back"){
               let backButton = UIButton(type: .system)
               backButton.setImage(backImage, for: .normal)
               backButton.addTarget(self, action:#selector(self.backClicked), for: .touchUpInside)
               self.setupLeftNavigationBar([backButton])
           }
           
           self.setNavigahtionTitle(title, .white)
           self.setNavigationBarHorizontalGradient(.white)
       }
       
       @objc func backClicked(sender : UIButton) {
           //Write button action here
           delegate?.updateList()
           self.dismiss(animated: true) {
               
           }
       }
}


