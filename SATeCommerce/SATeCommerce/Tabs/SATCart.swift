//
//  SATCart.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 18/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

class SATCart: UITableViewController, CartCellDelegate {
    func updateList() {
        SATCoreDataManager.shared.fetchMyCart { (carts) in
            self.cartItems = carts ?? []
            DispatchQueue.main.async {
                self.reload()
            }
        }
    }
    
    
    var cartItems: [SATMyCartViewModel] = []
    
    func setupNavigationBar() -> Void {
        self.setNavigahtionTitle("My Cart")
    }
    
    let cartCellReuseIdentifier = "SATCartCell"
    
    func setupTableView() -> Void {
        tableView.register(UINib(nibName: "SATCartCell", bundle: nil), forCellReuseIdentifier: cartCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.hidingEmptyTableViewRows()
    }
    
    func hidingEmptyTableViewRows(){
        tableView.tableFooterView = UIView(frame: .zero)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        SATCoreDataManager.shared.fetchMyCart { (carts) in
            self.cartItems = carts ?? []
            DispatchQueue.main.async {
                self.reload()
            }
        }
    }
    
    func restoreTable() {
        self.tableView.backgroundView = nil
    }
    
    func reload() -> Void {
        self.tableView.reloadData()
    }
    
    func setEmptyTableMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartItems.count == 0 {
            self.setEmptyTableMessage("No item found in cart \n Continue shoping")
        } else {
            self.restoreTable()
        }
        return cartItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCellReuseIdentifier, for: indexPath) as! SATCartCell
        cell.setCartItem(cartItems[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

