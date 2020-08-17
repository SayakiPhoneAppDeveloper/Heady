//
//  SideMenu.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
import UIKit

struct SideMenuItem {
    let index: CollectionMode?
    let title: String
    let icon: UIImage?
    let bgColor: UIColor?
    init(title: String, _ icon: UIImage? = nil, _ bgColor: UIColor? = .white, _ index: CollectionMode) {
        self.title = title
        self.icon = icon
        self.bgColor = bgColor
        self.index = index
    }
}

protocol SideMenu: UIViewController, SSkSideMenuDelegate {
    func showHideSideMenu(items: Array<SideMenuItem>, completion:@escaping ()->()) -> Void
}

extension SideMenu {
    func showHideSideMenu(items: Array<SideMenuItem>, completion:@escaping ()->()) -> Void {
        if let sideMenu: SSKSideMenuController = children.first(where: { String(describing: $0.classForCoder) == "SSKSideMenuController" }) as? SSKSideMenuController{
            print("we have one")
            sideMenu.hideTable {
                self.removeChildController(asChildViewController: sideMenu)
                completion()
            }
        }else{
            let sideMenuController: SSKSideMenuController = SSKSideMenuController(nibName: "SSKSideMenuController", bundle: nil)
            
            sideMenuController.delegate = self
            sideMenuController.items = items
            self.addChildController(asChildViewController: sideMenuController, toView: self.view, paddingLeft: 0.0, paddingRight: 0.0, paddingTop: 0.0, paddingBottom: 0.0)
            sideMenuController.showTable {
                completion()
            }
        }
    }
    
    func completeHide(menu: SSKSideMenuController){
        self.removeChildController(asChildViewController: menu)
    }
}
