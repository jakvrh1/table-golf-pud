//
//  PointTools.swift
//  TableGolf
//
//  Created by Jaka on 6/7/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class PointTools {

    // Multiplies x and y axis by scale value
    static func scale(point: CGPoint, by scale: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scale, y: point.y * scale)
    }
    
    // Sums a and b axis
    static func sum(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    // Substracts a and b axis
    static func substract(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    // Sums both a axis with b value
    static func sum(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x + b, y: a.y + b)
    }
    
    // Substracts both a axis with b value
    static func substract(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x - b, y: a.y - b)
    }
    
    // Axis square length
    static func squareLength(_ a: CGPoint) -> CGFloat {
        return a.x*a.x + a.y*a.y
    }
    
    // Axis lenght
    static func length(_ a: CGPoint) -> CGFloat {
        return sqrt(squareLength(a))
    }
    
    // Normalizes vector
    static func normalized(_ a: CGPoint) -> CGPoint {
        let pointLength = length(a)
        
        return pointLength > 0.0 ? scale(point: a, by: 1.0/pointLength) : CGPoint.zero
    }
    
    // Defines CGPoint from angle and radius
    static func cartesian(angle: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
    }
    
    // Angle
    static func angle(_ a: CGPoint) -> CGFloat {
        return atan2(a.y, a.x)
    }
}

