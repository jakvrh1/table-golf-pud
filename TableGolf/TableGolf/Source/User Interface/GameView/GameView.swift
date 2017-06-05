//
//  GameView.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class GameView: UIView {

    var scene: GameScene?
    
    private var scenePosition: ScenePosition = ScenePosition(center: CGPoint.zero, scale: 1.0)
    
// MARK: Drawing scene
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let scene = scene else {
            return
        }
        
        // Set scene position to center of the view and adjust scale so that the table fits the screen
        scenePosition = ScenePosition(center: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5),
                                      scale: min((frame.size.width/scene.table.radius) / 2, (frame.size.height/scene.table.radius) / 2))
        
        // Draw table
        UIColor.brown.setFill()
        fillCircle(circle: scene.table)
        
        // Draw exits
        UIColor.black.setFill()
        scene.exits.forEach({ exit in
            fillCircle(circle: exit)
        })
        
        // Draw coin
        UIColor.yellow.setFill()
        fillCircle(circle: scene.coin)
        
        
        // Draw obstacles
        UIColor.blue.setFill()
        scene.obstacles.forEach({ obstacle in
            fillCircle(circle: obstacle)
        })
        
    }
    
    private func fillCircle(circle: Circle) {
        let path = UIBezierPath(ovalIn: scenePosition.frame(forCircle: circle))
        path.fill()
    }
    
}

// MARK: - Screen position

fileprivate extension GameView {
    
    struct ScenePosition {
        
        var center: CGPoint
        var scale: CGFloat
        
        func frame(forCircle circle: Circle) -> CGRect {
            return CGRect(x: center.x + (circle.center.x - circle.radius) * scale,
                          y: center.y + (circle.center.y - circle.radius) * scale,
                          width: 2 * circle.radius * scale,
                          height: 2 * circle.radius * scale)
        }
        
    }
    
}
