//
//  SATShop.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

enum CollectionMode: Int {
    case Categories = 1
    case MostViewedProduct
    case MostOrderedProduct
    case MostSharedProduct
    case AllProduct
}

class SATShop: UIViewController, SideMenu, APIConnection, SSKNavigation {
    
    func itemInNavigationStack(itemCount: Int) {
        if itemCount>1 {
            addBackButton()
        }else {
            addMenuButton()
        }
    }
    
    
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var dataContainer: UIView!
    
    @IBOutlet weak var searchBarContainerHeightConstraint: NSLayoutConstraint!
    
    lazy var searchBar: SSKSearchBar = {
        return SSKSearchBar.loadSearchView()
    }()
    
    var syncButton: UIButton?
    
    func fetchDataFromDatabase(searchKey: String?) -> Void {
        switch currentMode {
            case .Categories:
                SATCoreDataManager.shared.fetchParentCategories { (categories) in
                    DispatchQueue.main.async {
                        self.reloadCategoryCollection(dataSource: categories)
                    }
                }
                break
            case .MostViewedProduct:
                SATCoreDataManager.shared.searchProductSortByMostViewed(mode: currentMode, searchKey: searchKey) { (products) in
                    DispatchQueue.main.async {
                        self.reloadProductCollection(dataSource: products)
                    }
                }
            case .MostOrderedProduct:
                SATCoreDataManager.shared.searchProductSortByMostOrdered(mode: currentMode, searchKey: searchKey) { (products) in
                    DispatchQueue.main.async {
                        self.reloadProductCollection(dataSource: products)
                    }
                }
            case .MostSharedProduct:
                SATCoreDataManager.shared.searchProductSortByMostShared(mode: currentMode, searchKey: searchKey) { (products) in
                    DispatchQueue.main.async {
                        self.reloadProductCollection(dataSource: products)
                    }
                }
            case .AllProduct:
                SATCoreDataManager.shared.searchProducts(mode: currentMode, searchKey: searchKey) { (products) in
                    DispatchQueue.main.async {
                        self.reloadProductCollection(dataSource: products)
                    }
                }
        }
    }
    
    func didSelectMenu(item: CollectionMode) {
        print("Menu clicked \(item)")
        searchBar.resetSearchBar()
        currentMode = item
        fetchDataFromDatabase(searchKey: nil)
    }
    
    var currentMode: CollectionMode = .AllProduct
    
    fileprivate func readFromServer(shouldResetPage: Bool) {
        self.syncButton?.startRotating()
        searchBar.resetSearchBar()
        fetchData { (isSuccess, errorMsg) in
            DispatchQueue.main.async {
                self.syncButton?.stopRotating()
            }
            if shouldResetPage{
                self.fetchDataFromDatabase(searchKey: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupSearchBar()
        self.fetchDataFromDatabase(searchKey: nil)
        readFromServer(shouldResetPage: true)
    }
}


//MARK:- Navigation bar
extension SATShop {
    
    fileprivate func addBackButton() {
        if let backImage = UIImage(named: "back"){
            let backButton = UIButton(type: .system)
            backButton.setImage(backImage, for: .normal)
            backButton.addTarget(self, action:#selector(self.backClicked), for: .touchUpInside)
            self.setupLeftNavigationBar([backButton])
        }
    }
    
    fileprivate func addMenuButton() {
        if let menuImage = UIImage(named: "menu"){
            let menuButton = UIButton(type: .system)
            menuButton.setImage(menuImage, for: .normal)
            menuButton.addTarget(self, action:#selector(self.menuClicked), for: .touchUpInside)
            self.setupLeftNavigationBar([menuButton])
        }
    }
    
    
    func setupNavigationBar() -> Void {
        self.clearNavigationBarItems()
        self.setNavigationBarColor(.white)
        self.setNavigationBarTintColor(.black)
        if let headyImage = UIImage(named: "heady")?.coloredImage(color: .red){
            self.setNavigationTitleImage(headyImage)
        }
        
        addMenuButton()
        
        if let syncImage = UIImage(named: "sync"){
            syncButton = UIButton(type: .system)
            syncButton?.setImage(syncImage, for: .normal)
            syncButton?.addTarget(self, action:#selector(self.syncClicked), for: .touchUpInside)
            self.setupRightNavigationBar([syncButton!])
        }
    }
    
    @objc func menuClicked(sender : UIButton) {
        //Write button action here
        searchBar.resetSearchBar()
        self.showHideSideMenu(items: [SideMenuItem(title: "Shop by Category", UIImage(named: "shop_by_category"), .white, .Categories), SideMenuItem(title: "Most Viewed", UIImage(named: "viewed"), .white, .MostViewedProduct), SideMenuItem(title: "It's Trending", UIImage(named: "ordered"), .white, .MostOrderedProduct), SideMenuItem(title: "Lucrative Products", UIImage(named: "shared"), .white, .MostSharedProduct), SideMenuItem(title: "All Products", UIImage(named: "all"), .white, .AllProduct)]) {
        }
    }
    
    @objc func syncClicked(sender : UIButton) {
        //Write button action here
        searchBar.resetSearchBar()
        sender.startRotating()
        readFromServer(shouldResetPage: true)
    }
    
    @objc func backClicked(sender : UIButton) {
        //Write button action here
        if let categoryCollection = presentedCategoryCollection(){
            categoryCollection.popFromNavigation()
        }
    }
}

extension SATShop: SSKSearchDelegate{
    
    func shouldShowSearch(shouldShow: Bool) -> Void {
        if shouldShow{
            self.searchBarContainerHeightConstraint.constant = 50.0
        }else{
            self.searchBarContainerHeightConstraint.constant = 0.0
        }
    }
    
    fileprivate func setupSearchBar() {
        searchBar.delegate = self
        self.searchBarContainer.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: self.searchBarContainer, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: self.searchBarContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: self.searchBarContainer, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: self.searchBarContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    //MARK:- EquipmentSearchDelegate Search Bar Delegate
    func cameraBtnTapped(){
        
    }
    
    func searchTextChanged(searchTxt: String) {
        self.fetchDataFromDatabase(searchKey: searchTxt)
    }
    
    func cancelSearch() {
        self.fetchDataFromDatabase(searchKey: nil)
    }
}

extension SATShop {
    func removeProductCollection() -> Void {
        if let prdctCol: SATProductCollection = self.children.first(where: { String(describing: $0.classForCoder) == "SATProductCollection" }) as? SATProductCollection{
            print("we have one")
            self.removeChildController(asChildViewController: prdctCol)
        }
    }
    
    func removeCategoryCollection() -> Void {
        if let catCol: UINavigationController = self.children.first(where: { String(describing: $0.classForCoder) == "UINavigationController" }) as? UINavigationController{
            print("we have one")
            self.removeChildController(asChildViewController: catCol)
        }
    }
    
    fileprivate func presentedCategoryCollection()->SATCategoryCollection?{
        if let catCol: UINavigationController = self.children.first(where: { String(describing: $0.classForCoder) == "UINavigationController" }) as? UINavigationController{
            print("we have one")
            return catCol.viewControllers.first as? SATCategoryCollection
        }else{
            return nil
        }
    }
    
    fileprivate func presentedProductCollection()->SATProductCollection?{
        if let prdctCol: SATProductCollection = self.children.first(where: { String(describing: $0.classForCoder) == "SATProductCollection" }) as? SATProductCollection{
            print("we have one")
            return prdctCol
        }else{
            return nil
        }
    }
    
    fileprivate func reloadCategoryCollection(dataSource: [SATCategoryViewModel]?) {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: {
            self.searchBarContainerHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.removeProductCollection()
            if let pcc = self.presentedCategoryCollection(){
                pcc.arrayElement = dataSource ?? []
                pcc.reload()
            }else{
                let categoryCollection = SATCategoryCollection.loadCategories()
                categoryCollection.navDelegate = self
                let navController: UINavigationController = UINavigationController(rootViewController: categoryCollection)
                navController.setNavigationBarHidden(true, animated: false)
                categoryCollection.arrayElement =  dataSource ?? []
                self.addChildController(asChildViewController: navController, toView: self.dataContainer)
            }
        }
    }
    
    fileprivate func reloadProductCollection(dataSource: [SATProductViewModel]?) {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: {
            self.searchBarContainerHeightConstraint.constant = 50.0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.removeCategoryCollection()
            if let ppc = self.presentedProductCollection(){
                ppc.arrayElement = dataSource ?? []
                ppc.reload()
            }else{
                let productCollection = SATProductCollection.loadProducts()
                productCollection.arrayElement =  dataSource ?? []
                self.addChildController(asChildViewController: productCollection, toView: self.dataContainer)
            }
        }
    }
}
