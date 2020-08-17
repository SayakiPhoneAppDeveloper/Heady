//
//  SATCategoryCollection.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

private let reuseIdentifierCategory = "SATCategoryCell"

protocol SSKNavigation: class {
    func itemInNavigationStack(itemCount: Int) -> Void
}

class SATCategoryCollection: SATDataCollection {
    
    var categoryStack = Stack<Array<SATCategoryViewModel>>()
    weak var navDelegate: SSKNavigation?
    var nsvStackItemCount: Int = 0
    
    class func loadCategories() -> SATCategoryCollection {
        let contentView = SATCategoryCollection(nibName: "SATDataCollection", bundle:  Bundle.init(for: SATDataCollection.self))
        return contentView
    }

    override func registerCell() -> Void {
        self.collectionView.register(UINib(nibName: reuseIdentifierCategory, bundle: Bundle.init(for: SATCategoryCell.self)), forCellWithReuseIdentifier: reuseIdentifierCategory)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryStack.push(arrayElement as! [SATCategoryViewModel])
        self.nsvStackItemCount = self.nsvStackItemCount+1
        navDelegate?.itemInNavigationStack(itemCount: self.nsvStackItemCount)
    }
    
    func popFromNavigation(){
        DispatchQueue.main.async {
            if let _ = self.navigationController?.viewControllers.last as? SATProductCollection {
                self.navigationController?.popViewController(animated: true)
                return
            }
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.fillMode = CAMediaTimingFillMode.forwards
            transition.duration = 0.5
            transition.subtype = CATransitionSubtype.fromLeft
            self.collectionView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
            // Update your data source here
            _ = self.categoryStack.pop()
            if let currentCategories = self.categoryStack.peek(){
                self.arrayElement = currentCategories
                self.nsvStackItemCount = self.nsvStackItemCount-1
                self.navDelegate?.itemInNavigationStack(itemCount: self.nsvStackItemCount)
                self.collectionView.reloadData()
            }
        }
    }
    
    func pushWithSubCategories(subCategories: Array<SATCategoryViewModel>) -> Void {
        DispatchQueue.main.async {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.fillMode = CAMediaTimingFillMode.forwards
            transition.duration = 0.5
            transition.subtype = CATransitionSubtype.fromRight
            self.collectionView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
            // Update your data source here
            self.arrayElement = subCategories
            self.categoryStack.push(self.arrayElement as! [SATCategoryViewModel])
            self.nsvStackItemCount = self.nsvStackItemCount+1
            self.navDelegate?.itemInNavigationStack(itemCount: self.nsvStackItemCount)
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCategory, for: indexPath) as! SATCategoryCell
    
        if let data = arrayElement[indexPath.item] as? SATCategoryViewModel{
            cell.setData(data: data)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVM = arrayElement[indexPath.item]
        SATCoreDataManager.shared.fetchChildComponents(parentCategoryId: NSNumber(value: categoryVM.id)) { (isSubCatewgory, childComponents) in
            if let isSubCatewgory = isSubCatewgory{
                if isSubCatewgory{
                    //Category
                    self.pushWithSubCategories(subCategories: childComponents as! Array<SATCategoryViewModel>)
                }else{
                    //Product
                     DispatchQueue.main.async {
                        let productCollection = SATProductCollection.loadProducts()
                        productCollection.arrayElement = childComponents as! Array<SATProductViewModel>
                        self.navigationController?.pushViewController(productCollection, animated: true)
                    }
                }
            }else{
                //no child exist
            }
        }
    }
    
    override func getNumberOfCellInRow() -> Int {
        return 1
    }
    
    override func getCellHeight() -> Int {
        return 100
    }

}
