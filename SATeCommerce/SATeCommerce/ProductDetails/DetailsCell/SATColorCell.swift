//
//  SATColorCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol ColorSelectionTableCellDelegate: class {
    func colorSelected(_ color: String?)
}

class SATColorCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! SATColorCollectionCell
        let colorStr = selectionItems[indexPath.row]
        cell.populateColor(color: UIColor(colorName: colorStr) ?? .red)
        cell.shouldSelect(isSelected: selectionItems[indexPath.row] == selectedItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = selectionItems[indexPath.row]
        collectionView.reloadData()
        delegate?.colorSelected(selectedItem)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionCellIdentifier = "SATColorCollectionCell"
    
    var selectionItems: [String] = []
    var selectedItem: String?
    
    weak var delegate: ColorSelectionTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        collectionView?.register(UINib(nibName: "SATColorCollectionCell", bundle: Bundle.init(for: SATColorCollectionCell.self as AnyClass)), forCellWithReuseIdentifier: collectionCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isAccessibilityElement = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(_ items: [String]?) -> Void {
        selectionItems = items ?? []
        collectionView.reloadData()
    }
    
}
