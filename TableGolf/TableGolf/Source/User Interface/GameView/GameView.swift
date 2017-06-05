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
    
// MARK: Drawing scene
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let table = scene?.table {
            UIColor.brown.setFill()
            fillCircle(circle: table)
        }
        
        scene?.exits.forEach({ exit in
            UIColor.black.setFill()
            fillCircle(circle: exit)
        })
        
        if let coin = scene?.coin {
            UIColor.yellow.setFill()
            fillCircle(circle: coin)
        }
        
        scene?.obstacles.forEach({ obstacle in
            UIColor.blue.setFill()
            fillCircle(circle: obstacle)
        })
        
    }

    private func fillCircle(circle: Circle) {
        guard let table = scene?.table else {
            return
        }
        
        let offset: CGPoint = CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5)
        let scale: CGFloat = min((frame.size.width/table.radius) / 2, (frame.size.height/table.radius) / 2)
        
        let path = UIBezierPath(ovalIn: CGRect(x: offset.x + (circle.center.x - circle.radius)*scale,
                                               y: offset.y + (circle.center.y - circle.radius)*scale,
                                               width: 2 * circle.radius * scale,
                                               height: 2 * circle.radius * scale))
        path.fill()
    }
    
}

