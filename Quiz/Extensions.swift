//
//  Extensions.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit


extension UIImage {
    
    // skalowanie grafiki do podanej wielkości
    
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
}
