//
//  Circle.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Circle: GameObject {
    
    var center: CGPoint = CGPoint.zero
    var radius: CGFloat = 0
    
    var descriptor: [String: Any] {
        return ["center": ["x": center.x, "y": center.y],"radius": radius]
    }
    
    convenience init(withCenter center: CGPoint, andRadius radius: CGFloat) {
        self.init()
        
        self.center = center
        self.radius = radius
    }
    
    convenience init(withDescriptor descriptor: [String: Any]) {
        self.init()
        
        if let center = descriptor["center"] as? [String: Any], let x = center["x"] as? Float, let y = center["y"] as? Float {
            self.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        if let radius = descriptor["radius"] as? Float {
            self.radius = CGFloat(radius)
        }
        
    }
}
