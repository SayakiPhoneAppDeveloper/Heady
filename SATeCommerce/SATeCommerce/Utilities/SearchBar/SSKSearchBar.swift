//
//  SSKSearchBar.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

protocol SSKSearchDelegate: class {
    func shouldShowCancelButton() -> Bool
    func cancelSearch()
    func cameraBtnTapped()
    func searchTextChanged(searchTxt: String)
}

extension SSKSearchDelegate {
    func shouldShowCancelButton() -> Bool {
        return true
    }
}

class SSKSearchBar: UIView, UISearchBarDelegate {

        var searchableText: String = ""
        
        class func loadSearchView() -> SSKSearchBar {
            let contentView = Bundle.init(for: SSKSearchBar.self).loadNibNamed("SSKSearchBar", owner: self, options: nil)?.first as? SSKSearchBar
            return contentView!
        }

        @IBOutlet weak var searchBar: UISearchBar!
        
        weak var delegate : SSKSearchDelegate?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            searchBar.delegate = self
            searchBar.showsBookmarkButton = true
            searchBar.setImage(UIImage(named: "camera")?.coloredImage(color: .gray), for: .bookmark, state: .normal)
    //        searchBar.setImage(UIImage(named: "search_clear"), for: .clear, state: .normal)
            // MARK: You may change position of bookmark button.
            //searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .bookmark)
            
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.font = UIFont(name : "Ubuntu" , size : 15.0)
                searchBar.searchTextField.layer.masksToBounds = true
                searchBar.searchTextField.layer.cornerRadius = 3.0
                searchBar.searchTextField.layer.borderColor = UIColor.init(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
                searchBar.searchTextField.layer.borderWidth = 1.0
            }else{
                for s in searchBar.subviews[0].subviews {
                    if s is UITextField {
                        (s as? UITextField)?.font = UIFont(name : "Ubuntu" , size : 15.0)
                        s.layer.masksToBounds = true
                        s.layer.cornerRadius = 3.0
                        s.layer.borderColor = UIColor.init(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
                        s.layer.borderWidth = 1.0
                    }
                }
            }
        }
        
        func shouldShowScanButton(isShow: Bool) {
            searchBar.showsBookmarkButton = isShow
            if isShow{
                searchBar.setImage(UIImage(named: "camera")?.coloredImage(color: .gray), for: .bookmark, state: .normal)
            }
        }
        
        func resetSearchBar() -> Void {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
        
        func searchForText(txt: String) -> Void {
            searchBar.text = txt
            searchBarSearchButtonClicked(searchBar)
        }
        
        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            if let del = self.delegate{
                del.cameraBtnTapped()
            }
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.resignFirstResponder()
            if let del = self.delegate{
                del.cancelSearch()
            }
        }
        
        @objc func searchTextChanged(){
            searchBar.accessibilityValue = searchableText
            if let del = self.delegate{
                del.searchTextChanged(searchTxt: searchableText)
            }
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(delegate?.shouldShowCancelButton() ?? true, animated: true)
            searchableText = searchBar.text ?? ""
            searchTextChanged()
        }
        
        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(false, animated: true)
//            if let del = self.delegate{
//                del.cancelSearch()
//            }
            return true
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchableText = searchBar.text ?? ""
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchableText = searchText
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchTextChanged), object: nil)
            self.perform(#selector(searchTextChanged), with: nil, afterDelay: 0.5)
        }
        
    }

