//
//  PointTools.swift
//  TableGolf
//
//  Created by Jaka on 6/7/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class PointTools {

    static func scale(point: CGPoint, by scale: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scale, y: point.y * scale)
    }
    
    static func sum(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    static func substract(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    static func sum(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x + b, y: a.y + b)
    }
    
    static func substract(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x - b, y: a.y - b)
    }
    
    static func squareLength(_ a: CGPoint) -> CGFloat {
        return a.x*a.x + a.y*a.y
    }
    
    static func length(_ a: CGPoint) -> CGFloat {
        return sqrt(squareLength(a))
    }
    
    static func normalized(_ a: CGPoint) -> CGPoint {
        let pointLength = length(a)
        
        return pointLength > 0.0 ? scale(point: a, by: 1.0/pointLength) : CGPoint.zero
    }
}

