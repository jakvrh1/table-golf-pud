//
//  PointTools.swift
//  TableGolf
//
//  Created by Jaka on 6/7/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class PointTools {

    /// Scales location with scale value
    ///
    /// - Parameters:
    ///   - point: location to be scaled
    ///   - scale: floating value which point gets scaled by
    /// - Returns: scalled location
    static func scale(point: CGPoint, by scale: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scale, y: point.y * scale)
    }
    
    /// Sums a and b points
    ///
    /// - Parameters:
    ///   - a: point value
    ///   - b: point value
    /// - Returns: new sum of a and b point
    static func sum(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    /// Substracts two locations
    ///
    /// - Parameters:
    ///   - a: first location which will be substracted by second location
    ///   - b: second location
    /// - Returns: substraction of a and b locations
    static func substract(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    

    /// Location axis summed with floating value
    ///
    /// - Parameters:
    ///   - a: location
    ///   - b: floating value used to add to location axis
    /// - Returns: point with axis summed by floatin value
    static func sum(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x + b, y: a.y + b)
    }
    
    
    /// Location axis substracted by floating value
    ///
    /// - Parameters:
    ///   - a: location
    ///   - b: value used to substract location axis
    /// - Returns: <#return value description#>
    static func substract(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        return CGPoint(x: a.x - b, y: a.y - b)
    }
    
    
    /// Square length from location
    ///
    /// - Parameter a: location
    /// - Returns: sum of both location axis multiplied by itself
    static func squareLength(_ a: CGPoint) -> CGFloat {
        return a.x*a.x + a.y*a.y
    }
    
    
    /// Location length
    ///
    /// - Parameter a: location
    /// - Returns: location length
    static func length(_ a: CGPoint) -> CGFloat {
        return sqrt(squareLength(a))
    }
    
    
    /// Normalizes location
    ///
    /// - Parameter a: location
    /// - Returns: normalized location
    static func normalized(_ a: CGPoint) -> CGPoint {
        let pointLength = length(a)
        
        return pointLength > 0.0 ? scale(point: a, by: 1.0/pointLength) : CGPoint.zero
    }
    
    /// Defines location from angle and radius
    ///
    /// - Parameters:
    ///   - angle: angle
    ///   - radius: radius
    /// - Returns: location defined from angle and radius
    static func cartesian(angle: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
    }
    
    // Angle
    
    /// Location angle
    ///
    /// - Parameter a: location
    /// - Returns: location angle
    static func angle(_ a: CGPoint) -> CGFloat {
        return atan2(a.y, a.x)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - a: <#a description#>
    ///   - b: <#b description#>
    /// - Returns: <#return value description#>
    static func dot(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return a.x*b.x + a.y*b.y
    }
    
}

