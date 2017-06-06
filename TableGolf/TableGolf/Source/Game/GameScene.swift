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
    var coin: Coin = Coin(withCenter: CGPoint.zero, andRadius: 1)
    
    
    var cancelArrow = true
    var isReadyToLaunch: Bool = false // Set to true when dragging
    /// Will always be normalized
    private(set) var launchDirection: CGPoint = CGPoint(x: 0.0, y: -1.0)
    private(set) var launchMagnitude: CGFloat = 1.0 // TODO: default to 1
    
    
    func setLaunchParameters(withStartPoint start: CGPoint, endPoint end: CGPoint) {
        launchDirection = CGPoint(x: start.x-end.x, y: start.y-end.y) // Use normalized(start-end)
        launchMagnitude = sqrt(pow((launchDirection.x),2)+pow((launchDirection.y),2)) // Use (start-end).length
        
        // Delete arrow if dragged back
        if launchMagnitude > 1.0 {
            launchMagnitude = 1.0
        } else if launchMagnitude >= 0.3 {
            cancelArrow = true
        }  else if cancelArrow {
            launchMagnitude = 0.0
        }
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

            
            func cartesian(angle: CGFloat, radius: CGFloat) -> CGPoint {
                return CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
            }
  
            obstacles = [
                Obstacle(withCenter: cartesian(angle: CGFloat.pi*2 * 0.0, radius: table.radius*0.7), andRadius: 8),
                Obstacle(withCenter: cartesian(angle: CGFloat.pi*2 * 0.3, radius: table.radius*0.7), andRadius: 12),
                Obstacle(withCenter: cartesian(angle: CGFloat.pi*2 * 0.5, radius: table.radius*0.2), andRadius: 10),
                Obstacle(withCenter: cartesian(angle: CGFloat.pi*2 * 0.8, radius: table.radius*0.5), andRadius: 9)
            ]
        }
    }
}

// MARK: - TutorialType

extension GameScene {
    
    enum TutorialType {
        case basic
    }
}

