//
//  UIView+Animation.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import UIKit

extension UIView {
    
    var isAnimating: Bool {
        return (self.layer.animationKeys()?.count ?? 0) > 0
    }
    
    func startRotating() -> Void {
        if !isAnimating{
            self.isUserInteractionEnabled = false
            let spinAnimation = CABasicAnimation()
            // start from 0
            spinAnimation.fromValue = 0
            // goes to 360
            spinAnimation.toValue = Double.pi * 2
            // define how long it will take to complete a 360
            spinAnimation.duration = 1
            // make spin infinitely
            spinAnimation.repeatCount = Float.infinity
            // do not remove when completed
            spinAnimation.isRemovedOnCompletion = false
            // specify the fill mode
            spinAnimation.fillMode = CAMediaTimingFillMode.forwards
            // animation acceleration
            spinAnimation.timingFunction = CAMediaTimingFunction (name: CAMediaTimingFunctionName.linear)
            // add the animation to the button layer
            self.layer.add(spinAnimation, forKey: "transform.rotation.z")
        }
    }
    
    func stopRotating() -> Void {
        if isAnimating{
            self.isUserInteractionEnabled = true
            self.layer.removeAllAnimations()
        }
    }
    
}
