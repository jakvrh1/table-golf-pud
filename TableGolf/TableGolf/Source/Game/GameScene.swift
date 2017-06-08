//
//  GameScene.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

protocol GameSceneDelegate: class {
    func gameSceneDidFinishWithVictory(sender: GameScene)
    func gameSceneDidFinishWithLose(sender: GameScene)
}

// MARK: - GameScene

class GameScene: GameObject {
    
    weak var delegate: GameSceneDelegate?
    
    
    
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
    private let magnitudeThreshold: CGFloat = 0.1
    
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
        
        for obstacle in obstacles {
            
            //CGPoint(x: coin.center.x - obstacle.center.x, y: coin.center.y - obstacle.center.y)
            let length = PointTools.length(CGPoint(x: coin.center.x - obstacle.center.x, y: coin.center.y - obstacle.center.y))
            
            let radiusLength = coin.radius + obstacle.radius
            
            if length < radiusLength {
                
                if PointTools.dot(PointTools.substract(obstacle.center, coin.center), coin.speed) > 0 {
                   // let normal = PointTools.normalized(obstacle.center - obstacle.center)
                    
                    let normal1 = PointTools.normalized(PointTools.substract(obstacle.center, coin.center))
                    let normal = CGPoint(x: normal1.y, y: -normal1.x)
                    
                    
                    coin.speed = PointTools.substract(PointTools.scale(point: normal, by: PointTools.dot(normal, coin.speed)*2.0), coin.speed)
                }
            }
        }
    }
    
//    func collision() -> Bool {
//        
//    }
    
    func launch() {
        if !isReadyToLaunch {
            return
        }

        let speedScale: CGFloat = 300.0
        coin.speed = PointTools.scale(point: launchDirection, by: speedScale * launchMagnitude)
        
        
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
            
            exits = [Exit(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.6, radius: table.radius*0.9), andRadius: 10),
            Exit(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.1, radius: table.radius*0.3), andRadius: 5)]
            
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

extension GameScene {
    func isCoinOnTable() -> Bool {
        let length = PointTools.length(CGPoint(x: table.center.x - coin.center.x, y: table.center.y - coin.center.y))
        
        let maxLength = table.radius
        
        
        //print("length: \(length) maxLength: \(maxLength)")
            
        if length > maxLength {
            return false
        }
        return true
    }
    
    func isCoinInFinish() -> Bool {
        
        for exit in exits {
            
            let length = PointTools.length(CGPoint(x: exit.center.x - coin.center.x, y: exit.center.y - coin.center.y))
            let maxLength = exit.radius
            
            //print("length: \(length) maxLength: \(maxLength)")
            
            if !(length > maxLength) {
                return true
            }
        }
        
        return false
    }
}

extension GameScene: CoinDelegate {
    func coinDidStopMoving(coin: Coin) {
        
        if !isCoinOnTable() {
            delegate?.gameSceneDidFinishWithLose(sender: self)
        } else if isCoinInFinish() {
            delegate?.gameSceneDidFinishWithVictory(sender: self)
        }
        canLaunch = true

    }
    
    func coinDidStartMoving(coin: Coin) {
        canLaunch = false
    }
    
}
