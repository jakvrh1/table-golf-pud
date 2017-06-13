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
    
    convenience init(withCenter center: CGPoint, andRadius radius: CGFloat) {
        self.init()
        
        self.center = center
        self.radius = radius
    }
}
