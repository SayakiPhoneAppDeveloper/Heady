//
//  SATSizeCell.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol SizeSelectionTableCellDelegate: class {
    func sizeSelected(_ size: Float?)
}

class SATSizeCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! SATSizeCollectionCell
        cell.populateSize(size: "\(selectionItems[indexPath.row])")
        cell.shouldSelect(isSelected: selectionItems[indexPath.row] == selectedItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = selectionItems[indexPath.row]
        collectionView.reloadData()
        delegate?.sizeSelected(selectedItem)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionCellIdentifier = "SATSizeCollectionCell"
    
    var selectionItems: [Float] = []
    var selectedItem: Float?
    
    weak var delegate: SizeSelectionTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        collectionView?.register(UINib(nibName: "SATSizeCollectionCell", bundle: Bundle.init(for: SATColorCollectionCell.self as AnyClass)), forCellWithReuseIdentifier: collectionCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isAccessibilityElement = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(_ items: [Float]?) -> Void {
        selectionItems = items ?? []
        collectionView.reloadData()
    }
    
}
