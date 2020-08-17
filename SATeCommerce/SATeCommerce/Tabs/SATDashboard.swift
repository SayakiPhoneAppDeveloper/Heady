//
//  SATDashboard.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATDashboard: UITabBarController {
    
    let centerBackground = UIView(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
    var centerButton: UIButton!
    
    private var shapeLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.delegate = self
        
        self.setupCenterView()
    }
    
    private func setupCenterView(){
        
        for subview in self.centerBackground.subviews {
            subview.removeFromSuperview()
        }
        
        centerButton = UIButton(type: .custom)
        centerButton.frame = CGRect(x: 0, y: 0, width: centerBackground.bounds.width-25, height: centerBackground.bounds.height-25)
        centerButton.center = CGPoint(x: centerBackground.bounds.width/2, y: centerBackground.bounds.height/2)
        centerButton.backgroundColor = .white
        
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = centerButton.frame.size
        gradient.colors = [UIColor.clear.cgColor,UIColor.white.withAlphaComponent(0.2).cgColor]
        gradient.cornerRadius = centerButton.frame.width / 2
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        centerButton.layer.addSublayer(gradient)
        
        //Shadow
        centerButton.layer.cornerRadius = centerButton.frame.width / 2
        centerButton.layer.shadowColor = UIColor.darkGray.cgColor
        centerButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        centerButton.layer.shadowRadius = 1.0
        centerButton.layer.shadowOpacity = 0.7
        centerButton.layer.masksToBounds = false
        
        centerButton.layer.cornerRadius = centerButton.frame.width / 2
        
        centerButton.setBackgroundImage(UIImage(named: "cart")?.coloredImage(color: .black), for: .normal)
        centerButton.setBackgroundImage(UIImage(named: "cart")?.coloredImage(color: .blue), for: .selected)
        centerButton.adjustsImageWhenHighlighted = false
        centerButton.addTarget(self, action: #selector(centerButtonAction(sender:)), for: .touchUpInside)
        
        self.centerBackground.addSubview(centerButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setupCenterButton() {
        centerBackground.removeFromSuperview()
        
        centerBackground.center = CGPoint(x: view.bounds.width/2, y: self.tabBar.frame.origin.y)
        centerBackground.layer.cornerRadius = centerBackground.frame.width / 2
        centerBackground.backgroundColor = UIColor.clear
        
        view.addSubview(centerBackground)
        view.layoutIfNeeded()
    }
    
    @objc private func centerButtonAction(sender: UIButton?) {
        self.selectedIndex = 2
        centerButton.isSelected = true
    }
    
    override func viewDidLayoutSubviews() {
        self.setupCenterButton()
    }
    
}

extension SATDashboard : UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.children.first is SATCart{
            self.centerButtonAction(sender: nil)
        }else{
            centerButton.isSelected = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.children.first is SATCart{
            return false
        }else {
            return true
        }
    }
}

extension SATDashboard {
    func assignTabs() {
        
        let shop = SATShop(nibName: "SATShop", bundle: nil)
        shop.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "shop"), selectedImage: UIImage(named: "shop")?.coloredImage(color: .blue))
        shop.tabBarItem.accessibilityIdentifier = "Shop_Tabbar_Identifier"
        
        
        let wishlist = SATWishlist(nibName: "SATWishlist", bundle: nil)
        wishlist.title = "Wishlist"
        wishlist.tabBarItem = UITabBarItem(title: "Wish list", image: UIImage(named: "wishlist"), selectedImage: UIImage(named: "wishlist")?.coloredImage(color: .blue))
        wishlist.tabBarItem.accessibilityIdentifier = "Wishlist_Tabbar_Identifier"
        
        let cart = SATCart(nibName: "SATCart", bundle: nil)
        cart.tabBarItem = UITabBarItem(title: "My Cart", image: nil, selectedImage: nil)
        cart.tabBarItem.accessibilityIdentifier = "Cart_Tabbar_Identifier"
        
        
        let notification = SATNotifications(nibName: "SATNotifications", bundle: nil)
        notification.title = "Notification"
        notification.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(named: "notification"), selectedImage: UIImage(named: "notification")?.coloredImage(color: .blue))
        notification.tabBarItem.accessibilityIdentifier = "Notification_Tabbar_Identifier"
        
        
        let settings = SATSettings(nibName: "SATSettings", bundle: nil)
        settings.title = "Settings"
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings")?.coloredImage(color: .blue))
        settings.tabBarItem.accessibilityIdentifier = "Settings_Tabbar_Identifier"
        
        
        var viewControllers : [UIViewController]
        viewControllers = [ shop, wishlist, cart, notification, settings]
        
        for viewController in viewControllers {
            let homeTappedImage = viewController.tabBarItem.selectedImage
            viewController.tabBarItem.selectedImage = homeTappedImage?.withRenderingMode(.alwaysOriginal)
        }
        
        self.viewControllers = viewControllers.map {
            let nav = UINavigationController.init(rootViewController: $0)
            return nav
        }
        
        self.tabBar.tintColor = UIColor.blue
    }
    
}
