//
//  SATWishlist.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATWishlist: UIViewController, SATProductDetailsDelegate {
    func updateList() {
        reloadWishlist()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWishlist()
    }

   fileprivate func presentedProductCollection()->SATProductCollection?{
        if let prdctCol: SATProductCollection = self.children.first(where: { String(describing: $0.classForCoder) == "SATProductCollection" }) as? SATProductCollection{
            print("we have one")
            return prdctCol
        }else{
            return nil
        }
    }
    
    fileprivate func reloadProduct(_ wishList: [SATProductViewModel]?) {
        if let ppc = self.presentedProductCollection(){
            ppc.arrayElement = wishList ?? []
            ppc.reload()
        }else{
            let productCollection = SATProductCollection.loadProducts()
            productCollection.arrayElement =  wishList ?? []
            productCollection.detailsDelegate = self
            self.addChildController(asChildViewController: productCollection, toView: self.view)
        }
    }
    
    func reloadWishlist() -> Void {
        SATCoreDataManager.shared.fetchWishlist { (wishList) in
            DispatchQueue.main.async {
                self.reloadProduct(wishList)
            }
        }
    }

}
