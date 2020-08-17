//
//  SSKSideMenuController.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 15/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol SSkSideMenuDelegate {
    func didSelectMenu(item: CollectionMode) -> Void
    func completeHide(menu: SSKSideMenuController)
}

class SSKSideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sideMenuTable: UITableView!{
        didSet {
            sideMenuTable.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var tableLeadingConstraint: NSLayoutConstraint!
    var items: Array<SideMenuItem> = []
    var delegate: SSkSideMenuDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        sideMenuTable.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuCellReuseIdentifier")
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func showTable(completion:@escaping ()->()) -> Void {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            self.tableLeadingConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }
    func hideTable(completion:@escaping ()->()) -> Void {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = .clear
            let width = self.sideMenuTable.frame.size.width
            self.tableLeadingConstraint.constant = -width
            self.view.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }

    @IBAction func hideSideMenu(_ sender: Any) {
        hideTable {
            self.delegate?.completeHide(menu: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellReuseIdentifier", for: indexPath)
        
        let menu = items[indexPath.row]
        
        cell.textLabel?.text = menu.title
        cell.backgroundColor = menu.bgColor
        if let icon = menu.icon{
            cell.imageView?.image = icon
            cell.imageView?.layer.cornerRadius = 5.0
            cell.imageView?.clipsToBounds = true
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideTable {
            let menu = self.items[indexPath.row]
            self.delegate?.completeHide(menu: self)
            self.delegate?.didSelectMenu(item: menu.index ?? .AllProduct)
        }
    }

}
