//
//  GradientBackground.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

@IBDesignable class GradientBackground: UIView {

    @IBInspectable var colour1: UIColor = UIColor(
        red: 21 / 255,
        green: 0 / 255,
        blue: 220 / 255,
        alpha: 1.0)
    @IBInspectable var colour2: UIColor = UIColor(
        red: 21 / 255,
        green: 0 / 255,
        blue: 150 / 255,
        alpha: 1.0)
    
    let gradientLayer = CAGradientLayer()
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let colors = [colour2.cgColor,
                      colour1.cgColor,
                      colour2.cgColor]
        gradientLayer.colors = colors
        
        let locations = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations as [NSNumber]?
        gradientLayer.frame = CGRect( x: bounds.origin.x - 10,
                                      y: bounds.origin.y,
                                      width: bounds.size.width + 20,
                                      height: bounds.size.height)
        layer.addSublayer(gradientLayer)
    }
/*
    override func layoutSubviews() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-1.0, -0.5, -0.0]
        gradientAnimation.toValue = [1.0, 1.5, 2.0]
        gradientAnimation.duration = 20.0
        gradientAnimation.repeatCount = Float.infinity
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
