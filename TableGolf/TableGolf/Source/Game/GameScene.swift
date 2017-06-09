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
    func gameSceneNeedsRefresh(sender: GameScene)
    func gameSceneDidCollide(sender: GameScene)
    func gameSceneDidChangeNumberOfMoves(sender: GameScene, to numberOfMoves: Int)
}

// MARK: - GameScene

class GameScene: GameObject {
    weak var delegate: GameSceneDelegate?

    // Game objects
    var obstacles = [Obstacle]()
    var exits = [Exit]()
    var table: Table = Table(withCenter: CGPoint.zero, andRadius: 10)
    var coin: Coin = Coin(withCenter: CGPoint.zero, andRadius: 1) {
        didSet {
            coin.delegate = self
        }
    }
    
    fileprivate var displayLink: CADisplayLink? = nil
    
    // Game status
    var levelName: String = "basic"
    var currentLevel: Int = 0
    
    // Coin properties
    fileprivate(set) var canLaunch: Bool = true // Set to true when coin isn't moving
    private(set) var isReadyToLaunch: Bool = false // Set to true when dragging
    // Used to scale launchMagnitude (to give coin more appropriate speed)
    private let speedScale: CGFloat = 300.0
    fileprivate var numberOfMoves: Int = 0
    
    // Will always be normalized
    // Direction in which coin is moving
    private(set) var launchDirection: CGPoint = CGPoint(x: 1.0, y: 1.0)
    // Value represents how much we drag coin
    private(set) var launchMagnitude: CGFloat = 0.0
    // Length between starting locationg and end location
    private var directionLenght: CGFloat = 0.0
    private let magnitudeThreshold: CGFloat = 0.1
    
    func setLaunchParameters(withStartPoint start: CGPoint, endPoint end: CGPoint) {
        
        guard canLaunch == true else {
            return
        }
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
        checkCollision()
    }
    
    func checkCollision() {
        // Checks if obstacle is in the way of coin end location
        for obstacle in obstacles {
            let coinToObstacle = PointTools.substract(obstacle.center, coin.center)
            let distance = PointTools.length(coinToObstacle)
            
            let radiusLength = coin.radius + obstacle.radius
            
            // if sqrt((obstacle.x-coin.x)^2+(obstacle.y-coin.y)^2) < o.radius+c.radius
            if distance < radiusLength {
                // if dot(object.center - coin.center, coin.speed) > 0
                if PointTools.dot(PointTools.substract(obstacle.center, coin.center), coin.speed) > 0 {
                    // N1 = (obstacle.center - coin.center).normalized
                    let normal1 = PointTools.normalized(coinToObstacle)
                    // N2 = (N1y, -N1x)
                    let normal = CGPoint(x: normal1.y, y: -normal1.x)
                    // S = N2 * dot(N2, So)*2 -So
                    coin.speed = PointTools.substract(PointTools.scale(point: normal, by: PointTools.dot(normal, coin.speed)*2.0), coin.speed)
                }
                delegate?.gameSceneDidCollide(sender: self)
            }
        }
    }
    
    func launch() {
        if !isReadyToLaunch {
            return
        }
        
        coin.speed = PointTools.scale(point: launchDirection, by: speedScale * launchMagnitude)
        
        isReadyToLaunch = false
    }
    
    @objc func onDisplayLink() {
        move(dt: 1.0/60.0)
        delegate?.gameSceneNeedsRefresh(sender: self)
    }
    
// MARK: Initialization
 
    convenience init(levelNumber: Int) {
        self.init()
        
        Level.initializeLevels()

        currentLevel = levelNumber
        loadNewLevel()
        
        coin.delegate = self
    }
    
    func loadNewLevel() {
        if currentLevel < Level.getAllLevels().count {
            levelName = Level.getAllLevels()[currentLevel].levelName
            coin = Level.getAllLevels()[currentLevel].coin
            table = Level.getAllLevels()[currentLevel].table
            obstacles = Level.getAllLevels()[currentLevel].obstacles
            exits = Level.getAllLevels()[currentLevel].exits
            currentLevel += 1
            numberOfMoves = 0
        }
    }
}

// MARK: Coin delegate

extension GameScene: CoinDelegate {
    
    private func isCoinOnTable() -> Bool {
        let length = PointTools.length(CGPoint(x: table.center.x - coin.center.x, y: table.center.y - coin.center.y))
        let maxLength = table.radius
        
        if length > maxLength {
            return false
        }
        
        return true
    }
    
    private func isCoinInExit() -> Bool {
        for exit in exits {
            let length = PointTools.length(CGPoint(x: exit.center.x - coin.center.x, y: exit.center.y - coin.center.y))
            let maxLength = exit.radius
            
            if length < maxLength {
                return true
            }
        }
        
        return false
    }
    
    func coinDidStopMoving(coin: Coin) {
        if !isCoinOnTable() {
            delegate?.gameSceneDidFinishWithLose(sender: self)
        } else if isCoinInExit() {
            delegate?.gameSceneDidFinishWithVictory(sender: self)
        }
        
        canLaunch = true
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func coinDidStartMoving(coin: Coin) {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
            displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        }
        
        canLaunch = false
        numberOfMoves += 1
        delegate?.gameSceneDidChangeNumberOfMoves(sender: self, to: numberOfMoves)
    }
}
