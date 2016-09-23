//
//  Label1.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit

class Label1: UILabel {
    
    
    override func draw(_ rect: CGRect) {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
    }
}
