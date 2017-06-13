//
//  Level.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Level {
    
    static private(set) var allLevels: [Level] = []
    
    // Level objects
    public var obstacles: [Obstacle]
    public var exits: [Exit]
    public var table: Table
    public var coin: Coin
    
    let levelName: String
    
    init(levelName: String, coin: Coin, table: Table, exits: [Exit], obstacles: [Obstacle]) {
        self.coin = coin
        self.exits = exits
        self.table = table
        self.obstacles = obstacles
        
        self.levelName = levelName
    }
    
    static func getAllLevels() -> [Level] {
        return allLevels
    }
    
    static func initializeLevels() {
        var levels: [Level] = [Level]()
        var table = Table(withCenter: CGPoint.zero, andRadius: 100)
        
        levels.append(
            Level(levelName: "lvl1",
                  coin: Coin(withCenter: CGPoint(x: 90, y: 0), andRadius: 4),
                  table: table,
                  exits: [Exit(withCenter: CGPoint(x: -90, y: 0), andRadius: 10)],
                  obstacles: [
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.0, radius: table.radius*0.7), andRadius: 8),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.3, radius: table.radius*0.7), andRadius: 12),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.5, radius: table.radius*0.2), andRadius: 10),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.8, radius: table.radius*0.5), andRadius: 9)
                ])
        )
        
        table = Table(withCenter: CGPoint.zero, andRadius: 100)
        levels.append(
            Level(levelName: "lvl2",
                  coin: Coin(withCenter: CGPoint(x: 0, y: 0), andRadius: 4),
                  table: table,
                  exits: [Exit(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.6, radius: table.radius*0.9), andRadius: 10),
                          Exit(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.1, radius: table.radius*0.3), andRadius: 5)],
                  obstacles: [
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.0, radius: table.radius*0.7), andRadius: 8),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.3, radius: table.radius*0.7), andRadius: 20),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.5, radius: table.radius*0.2), andRadius: 2),
                    Obstacle(withCenter: PointTools.cartesian(angle: CGFloat.pi*2 * 0.8, radius: table.radius*0.5), andRadius: 12)
                ])
        )
        
        allLevels = levels
    }
}
