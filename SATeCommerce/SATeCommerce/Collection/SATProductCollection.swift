//
//  SATProductCollection.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

private let reuseIdentifierProduct = "SATProductCell"

class SATProductCollection: SATDataCollection, SATProductDetailsDelegate {
    func updateList() {
        detailsDelegate?.updateList()
    }
    weak var detailsDelegate: SATProductDetailsDelegate?
    class func loadProducts() -> SATProductCollection {
        let contentView = SATProductCollection(nibName: "SATDataCollection", bundle:  Bundle.init(for: SATDataCollection.self))
        return contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = arrayElement[indexPath.item] as? SATProductViewModel{
            let details = SATProductDetails(nibName: "SATProductDetails", bundle: nil)
            let navController: UINavigationController = UINavigationController(rootViewController: details)
            navController.modalPresentationStyle = .pageSheet
            details.setProduct(productId: NSNumber(value: data.id))
            details.delegate = self
            navController.presentationController?.delegate = self
            present(navController, animated: true)
        }
    }
    
    override func registerCell() -> Void {
        self.collectionView.register(UINib(nibName: reuseIdentifierProduct, bundle: Bundle.init(for: SATProductCell.self)), forCellWithReuseIdentifier: reuseIdentifierProduct)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierProduct, for: indexPath) as! SATProductCell
        if let data = arrayElement[indexPath.item] as? SATProductViewModel{
            cell.setData(data: data)
        }
        return cell
    }
    
    override func getNumberOfCellInRow() -> Int {
        return 2
    }
    
    override func getCellHeight() -> Int {
        return 200
    }
}

extension SATProductCollection: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss( _ presentationController: UIPresentationController) {
        if #available(iOS 13, *) {
            DispatchQueue.main.async {
                self.detailsDelegate?.updateList()
            }
        }
    }
}
