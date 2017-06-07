//
//  GameScene.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

// MARK: - GameScene

class GameScene: GameObject {
    
    var obstacles = [Obstacle]()
    var exits = [Exit]()
    var table: Table = Table(withCenter: CGPoint.zero, andRadius: 10)
    var coin: Coin = Coin(withCenter: CGPoint.zero, andRadius: 1) {
        didSet {
            coin.delegate = self
        }
    }
    
    fileprivate(set) var canLaunch: Bool = true
    private(set) var isReadyToLaunch: Bool = false // Set to true when dragging
    /// Will always be normalized
    private(set) var launchDirection: CGPoint = CGPoint(x: 1.0, y: 1.0)
    private(set) var launchMagnitude: CGFloat = 0.0
    private var directionLenght: CGFloat = 0.0
    private let magnitudeThreshold: CGFloat = 0.3
    
    func setLaunchParameters(withStartPoint start: CGPoint, endPoint end: CGPoint) {
        let direction = PointTools.substract(start, end)
        directionLenght = PointTools.length(direction)
        
        launchDirection = PointTools.normalized(direction)
        
        launchMagnitude = {
            if directionLenght < magnitudeThreshold {
                isReadyToLaunch = false
                return 0.0
            } else {
                isReadyToLaunch = true
                return max(0, min(directionLenght, 1))
            }
        }()
    }
    
    func move(dt: TimeInterval) {
        coin.move(dt: dt)
    }
    
    func launch() {
        if !isReadyToLaunch {
            return
        }

        let speedScale: CGFloat = 100.0
        coin.speed = PointTools.scale(point: launchDirection, by: speedScale)
        isReadyToLaunch = false
        
    }
    
// MARK: Initialization
 
    convenience init(withTutorialType tutorialType: TutorialType) {
        self.init()
        
        switch tutorialType {
        case .basic:
            // Object positions
            table = Table(withCenter: CGPoint.zero, andRadius: 100)
            coin = Coin(withCenter: CGPoint(x: 90, y: 0), andRadius: 4)
            exits = [Exit(withCenter: CGPoint(x: -90, y: 0), andRadius: 10)]
  
            obstacles = [
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.0, radius: table.radius*0.7), andRadius: 8),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.3, radius: table.radius*0.7), andRadius: 12),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.5, radius: table.radius*0.2), andRadius: 10),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.8, radius: table.radius*0.5), andRadius: 9)
            ]
        case .lvl1:
            // Object positions
            table = Table(withCenter: CGPoint.zero, andRadius: 100)
            coin = Coin(withCenter: CGPoint(x: 0, y: 0), andRadius: 4)
            //exits = [Exit(withCenter: CGPoint(x: -90, y: 90), andRadius: 10)]
            
            exits = [Exit(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.6, radius: table.radius*0.9), andRadius: 10)]
            
            obstacles = [
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.0, radius: table.radius*0.7), andRadius: 8),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.3, radius: table.radius*0.7), andRadius: 20),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.5, radius: table.radius*0.2), andRadius: 2),
                Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.8, radius: table.radius*0.5), andRadius: 12)
            ]
        }
        
        coin.delegate = self
    }
}

// MARK: - TutorialType

extension GameScene {
    
    enum TutorialType {
        case basic
        case lvl1
    }
}

extension GameScene: CoinDelegate {
    func coinDidStopMoving(coin: Coin) {
        canLaunch = true
    }
    
    func coinDidStartMoving(coin: Coin) {
        canLaunch = false
    }
}
