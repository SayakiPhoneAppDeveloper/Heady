//
//  UIView+Transform.swift
//  TabBarPOC
//
//  Created by Sayak Khatua on 20/03/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

extension UIView{
    func rotate(_ rotationAngleDegree: CGFloat) -> Void {
        self.transform = self.transform.rotated(by: CGFloat((rotationAngleDegree * .pi)/180))
    }
    
    func getRotationDegree() -> CGFloat {
        let radians = atan2(self.transform.b, self.transform.a)
        let degrees = radians * 180 / .pi
        return degrees
    }
}
