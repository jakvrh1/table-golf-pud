//
//  Level.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Level {
    
    static private var loadedLevels: [Level]? = nil
    static var allLevels: [Level] {
        if let loadedLevels = loadedLevels {
            return loadedLevels
        } else {
            initializeLevels()
            return loadedLevels ?? []
        }
    }
    
    // Level objects
    var obstacles: [Obstacle] = [Obstacle]()
    var exits: [Exit] = [Exit]()
    var table: Table = Table(withCenter: CGPoint.zero, andRadius: 10.0)
    var coin: Coin = Coin(withCenter: CGPoint.zero, andRadius: 4.0)
    
    var name: String = "New level"
    
    init() {
        
    }
    
    convenience init(name: String, coin: Coin, table: Table, exits: [Exit], obstacles: [Obstacle]) {
        self.init()
        self.coin = coin
        self.exits = exits
        self.table = table
        self.obstacles = obstacles
        
        self.name = name
    }
    
    static func saveLevel(level: Level) {
        var newLevels = allLevels
        newLevels.append(level)
        loadedLevels = newLevels

        serializeDataIntoJSON()
    }
    
    static func removeLevel(index: Int) {
        loadedLevels?.remove(at: index)
        serializeDataIntoJSON()
    }
    
    private static func initializeLevels() {
        deserializeDataFromJSON()
        
        if loadedLevels != nil{
            return
        }
        
        var levels: [Level] = [Level]()
        var table = Table(withCenter: CGPoint.zero, andRadius: 100)
        
        levels.append(
            Level(name: "lvl1",
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
            Level(name: "lvl2",
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
        
        loadedLevels = levels
    }
    
    private static var levelsFileURL: URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Levels.json")
    }
    
    static func serializeDataIntoJSON() {
        let levelsDescriptor: [[String: Any]] = self.allLevels.flatMap { level in
            var descriptor = [String: Any]()
            
            descriptor["name"] = level.name

            descriptor["coin"] = level.coin.descriptor
            
            let exitsDescriptor: [[String: Any]] = level.exits.flatMap{ exit in
                return exit.descriptor
            }
            descriptor["exits"] = exitsDescriptor
            
            let obstaclesDescriptor: [[String: Any]] = level.obstacles.flatMap{ obstacle in
                return obstacle.descriptor
            }
            descriptor["obstacles"] = obstaclesDescriptor
            
            descriptor["table"] = level.table.descriptor
            
            return descriptor
        }
        
        if let url = levelsFileURL, let jsonData = try? JSONSerialization.data(withJSONObject: levelsDescriptor, options: .prettyPrinted) {
            try? jsonData.write(to: url)
        }
        
    }
    
    static func deserializeDataFromJSON() {
        // print(try! JSONSerialization.jsonObject(with: (try! Data(contentsOf: jsonFilePath!)), options: .allowFragments))

        if let url = levelsFileURL, let data = try? Data(contentsOf: url) {
            guard let object = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String:Any]] else {
                return
            }

            let levels: [Level] = object.flatMap({ descriptor in
                let level = Level()
                
                if let name = descriptor["name"] as? String {
                    level.name = name
                }
                
                if let coin = descriptor["coin"] as? [String: Any] {
                    level.coin = Coin(withDescriptor: coin)
                }
                
                if let table = descriptor["table"] as? [String: Any] {
                    level.table = Table(withDescriptor: table)
                }
                
                if let obstacles = descriptor["obstacles"] as? [[String: Any]] {
                    level.obstacles = obstacles.flatMap { Obstacle(withDescriptor: $0) }
                }
                
                if let exits = descriptor["exits"] as? [[String: Any]] {
                    level.exits = exits.flatMap { Exit(withDescriptor: $0) }
                }
                
                return level
                
            })
            // checks whether we had any levels in JSON file
            if levels.count == 0 {
                loadedLevels = nil
            } else {
                loadedLevels = levels
            }
        }
    }
}
