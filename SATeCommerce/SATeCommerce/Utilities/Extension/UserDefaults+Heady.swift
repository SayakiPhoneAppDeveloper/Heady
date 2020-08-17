//
//  UserDefaults+Heady.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 17/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
enum UserDefaultsKeys : String {
    case WISHLIST
}
extension UserDefaults{
    func addProductToWishlist(_ value: NSNumber) -> Void {
        var wishlist = getWishlist()
        wishlist.append(value)
        set(wishlist, forKey: UserDefaultsKeys.WISHLIST.rawValue)
    }
    
    func removeProductFromWishlist(_ value: NSNumber) -> Void {
        var wishlist = getWishlist()
        if let index = wishlist.firstIndex(of: value){
            wishlist.remove(at: index)
        }
        set(wishlist, forKey: UserDefaultsKeys.WISHLIST.rawValue)
    }
    
    func getWishlist() -> [NSNumber] {
        return array(forKey: UserDefaultsKeys.WISHLIST.rawValue) as? [NSNumber] ?? []
    }
}
