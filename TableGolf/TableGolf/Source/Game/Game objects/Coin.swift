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
    
    var speed: CGPoint = CGPoint.zero {
        didSet {
            if oldValue == CGPoint.zero && speed != CGPoint.zero {
                delegate?.coinDidStartMoving(coin: self)
            } else if oldValue != CGPoint.zero && speed == CGPoint.zero {
                delegate?.coinDidStopMoving(coin: self)
            }
        }
    }
    
    func move(dt: TimeInterval) {
        center = PointTools.sum(center, PointTools.scale(point: speed, by: CGFloat(dt)))
        
        let fixedFriction: CGFloat = 2
        let linearSpeedFriction: CGFloat = 0.001
        
        let friction = (fixedFriction + PointTools.length(speed)*linearSpeedFriction)*CGFloat(dt)
        
        
        if friction < PointTools.length(speed) {
            speed = PointTools.sum(speed, PointTools.scale(point: speed, by: -friction))
        } else {
            speed = CGPoint.zero
        }
    }
    
    
}


