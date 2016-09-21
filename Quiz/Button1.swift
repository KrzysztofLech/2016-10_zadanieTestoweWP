//
//  Button1.swift
//  Quiz
//
//  Created by Black Thunder on 21.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class Button1: UIButton {

    override func draw(_ rect: CGRect) {
        
        layer.backgroundColor = UIColor(red: 255/255, green: 194/255, blue: 0/255, alpha: 1.0).cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.8
        
        layer.cornerRadius = 25.0
    }
}
