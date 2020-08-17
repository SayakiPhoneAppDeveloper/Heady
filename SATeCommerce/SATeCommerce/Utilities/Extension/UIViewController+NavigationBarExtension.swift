//
//  UIViewController+Extension.swift
//  TabBarPOC
//
//  Created by Sayak Khatua on 28/02/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func addGradient(_ toAlpha: CGFloat, _ color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [
            color.withAlphaComponent(0).cgColor,
            color.withAlphaComponent(toAlpha).cgColor,
            color.withAlphaComponent(toAlpha).cgColor
            
        ]
        gradient.startPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).0
        gradient.endPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).1
        gradient.locations = [0, 0.8, 1]
        var frame = bounds
        frame.size.height += UIApplication.shared.statusBarFrame.size.height
        frame.origin.y -= UIApplication.shared.statusBarFrame.size.height
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient(){
        layer.sublayers?.forEach { if $0.isKind(of: CAGradientLayer.self) { $0.removeFromSuperlayer() } }
    }
}

extension UIViewController{
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setNavigationBarTintColor(_ color: UIColor?) -> Void {
        self.navigationController?.navigationBar.tintColor = color ?? .black
    }
    
    fileprivate func setupLeftButtonItems(_ barButtonItemsArray: [UIBarButtonItem]) {
        if let rightItems = navigationItem.leftBarButtonItems, rightItems.count>0{
            let labelItems = rightItems.filter({ (item) -> Bool in
                if let v = item.customView, v.isKind(of: UILabel.self){
                    return true
                }
                return false
            })
            if labelItems.count>0 {
                for item in barButtonItemsArray.reversed() {
                    navigationItem.leftBarButtonItems?.insert(item, at: 0)
                }
            }else{
                navigationItem.leftBarButtonItems = barButtonItemsArray
            }
        }else{
            navigationItem.leftBarButtonItems = barButtonItemsArray
        }
    }
    
    func setupLeftNavigationBar(_ leftButtons: [UIButton]?) {
        if let leftButtons = leftButtons, leftButtons.count>0{
            var barButtonItemsArray: [UIBarButtonItem] = []
            for button in leftButtons {
                barButtonItemsArray.append(UIBarButtonItem(customView: button))
            }
            setupLeftButtonItems(barButtonItemsArray)
        }
    }
    
    func setupRightNavigationBar(_ rightButtons: [UIButton]?) {
        if let rightButtons = rightButtons, rightButtons.count>0{
            var barButtonItemsArray: [UIBarButtonItem] = []
            for button in rightButtons {
                barButtonItemsArray.append(UIBarButtonItem(customView: button))
            }
            navigationItem.rightBarButtonItems = barButtonItemsArray
        }
    }
    
    func clearNavigationBarItems() -> Void{
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        self.navigationController?.navigationBar.removeGradient()
    }
    
    func setNavigationBarColor( _ color: UIColor?) -> Void {
        self.navigationController?.navigationBar.barTintColor = color ?? .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setNavigahtionTitle(_ title: String, _ color: UIColor? = nil) -> Void {
        navigationItem.title = title
        if let color = color{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        }
    }
    
    func setNavigationTitleImage(_ titleImage: UIImage) -> Void {
        let imageView = UIImageView(image:titleImage)
        self.navigationItem.titleView = imageView
    }
    
    func setNavigahtionTitleAtLeft(_ title: String, _ color: UIColor? = nil) -> Void {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = color ?? .black
        label.text = title
        if self.navigationItem.leftBarButtonItems == nil{
            self.navigationItem.leftBarButtonItems = []
        }
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem.init(customView: label))
    }
    
    func setNavigationBarHorizontalGradient( _ color: UIColor) -> Void{
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.addGradient(0.3, color)
        }
    }
    
    func setNavigationBarVarticalGradient( _ color: UIColor) -> Void{
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.addGradient(0.3, color)
        }
    }
}

public extension UIViewController{
    
    func addChildController(asChildViewController viewController: UIViewController, toView: UIView, paddingLeft: CGFloat = 0.0, paddingRight: CGFloat = 0.0, paddingTop: CGFloat = 0.0, paddingBottom: CGFloat = 0.0) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        toView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: viewController.view!, attribute: .leading, relatedBy: .equal, toItem: toView, attribute: .leading, multiplier: 1.0, constant: paddingLeft).isActive = true
        NSLayoutConstraint(item: viewController.view!, attribute: .trailing, relatedBy: .equal, toItem: toView, attribute: .trailing, multiplier: 1.0, constant: paddingRight).isActive = true
        NSLayoutConstraint(item: viewController.view!, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: paddingTop).isActive = true
        NSLayoutConstraint(item: viewController.view!, attribute: .bottom, relatedBy: .equal, toItem: toView, attribute: .bottom, multiplier: 1.0, constant: paddingBottom).isActive = true
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func removeChildController(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
}

public extension UIViewController{
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func backOrDismiss(animated: Bool, completion: (() -> Swift.Void)? = nil){
        if isModal() {
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            UIView.animate(withDuration: 0, animations: { self.navigationController?.popViewController(animated: animated)})
            { _ in
                completion?()
            }
        }
    }
}


extension UIViewController {
    
    class func loadFromNib<T: UIViewController>( fileName: String? = nil) -> T {
         return T(nibName: (fileName ?? String(describing: self)), bundle: nil)
    }
    
    class func loadFrom<T: UIViewController, U: UIViewController>(nib nabName: U.Type) -> T {
        return loadFromNib(fileName: String(describing: nabName))
    }
    
    class func loadFromXIB<T: UIViewController, P: UIViewController>( fileName: String? = nil, type: P? = nil ) -> T {
         return T(nibName: (fileName ?? String(describing: self)), bundle: nil)
    }
}

extension UIViewController {

    /// Check if current viewcontroller size class.
    func isBeingPresentedInFormSheet() -> Bool {
        if let presentingViewController = presentingViewController {
            return traitCollection.horizontalSizeClass == .compact && presentingViewController.traitCollection.horizontalSizeClass == .regular
        }
        return false
    }
    
    /// A Boolean indicating whether the current view controller is being preseneted in form sheet or not.
    /// - Author: Gouranga Sasmal
    public func isBeingPresentedAsFormSheet() -> Bool {
        let traitCollection = self.traitCollection
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
    }
}

