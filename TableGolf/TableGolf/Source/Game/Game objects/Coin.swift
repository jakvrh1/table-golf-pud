//
//  Coin.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

protocol CoinDelegate: class {
    func coinDidStartMoving(coin: Coin)
    func coinDidStopMoving(coin: Coin)
}

class Coin: Circle {
    weak var delegate: CoinDelegate?
    
    // Friction properties to slowdown coin speed
    private let fixedFriction: CGFloat = 75
    private let linearSpeedFriction: CGFloat = 1
    
    var speed: CGPoint = CGPoint.zero {
        didSet {
            // Checks if coin started moving
            if oldValue == CGPoint.zero && speed != CGPoint.zero {
                delegate?.coinDidStartMoving(coin: self)
            }
            // Checks if coin stoped moving
            else if oldValue != CGPoint.zero && speed == CGPoint.zero {
                delegate?.coinDidStopMoving(coin: self)
            }
        }
    }
    
    func move(dt: TimeInterval) {
        center = PointTools.sum(center, PointTools.scale(point: speed, by: CGFloat(dt)))
        
        let speedLength = PointTools.length(speed)
        let friction = (fixedFriction + speedLength*linearSpeedFriction)*CGFloat(dt)

        // Slowdown coin by friction every frame until friction becomes bigger than actual speedLength
        if friction < speedLength {
            speed = PointTools.sum(speed, PointTools.scale(point: speed, by: -friction/speedLength))
        } else {
            speed = CGPoint.zero
        }
    }
    
}


