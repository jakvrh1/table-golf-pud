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
    
    
// MARK: Initialization
 
    init(withTutorialType tutorialType: TutorialType) {
        
        switch tutorialType {
        case .basic:
            table = Table(withCenter: CGPoint.zero, andRadius: 100)
            coin = Coin(withCenter: CGPoint(x: 90, y: 0), andRadius: 4)
            exits = [Exit(withCenter: CGPoint(x: -90, y: 0), andRadius: 10)]
            obstacles = [
                Obstacle(withCenter: CGPoint(x: -45, y: 0), andRadius: 8),
                Obstacle(withCenter: CGPoint(x: -45, y: 45), andRadius: 8),
                Obstacle(withCenter: CGPoint(x: 0, y: 45), andRadius: 8),
                Obstacle(withCenter: CGPoint(x: -80, y: -60), andRadius: 8),
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
