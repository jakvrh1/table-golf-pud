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
    var cameraMode: CameraMode = .fullScene

    var highlightedObject: Circle? = nil
    
    private var scenePosition: ScenePosition = ScenePosition(offset: CGPoint.zero, center: CGPoint.zero, scale: 1.0)
    
// MARK: Drawing Scene
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let scene = scene else {
            return
        }
        
        switch cameraMode {
        case .fullScene:
            scenePosition = ScenePosition(offset: CGPoint(x: frame.size.width*0.5,
                                                          y: frame.size.height*0.5),
                                          center: CGPoint(x: scene.table.center.x,
                                                          y: scene.table.center.y),
                                          scale: min((frame.size.width/scene.table.radius) / 2, (frame.size.height/scene.table.radius) / 2))
        case .followCoin(let scale):
            scenePosition = ScenePosition(offset: CGPoint(x: frame.size.width*0.5,
                                                          y: frame.size.height*0.5),
                                          center: CGPoint(x: scene.coin.center.x,
                                                          y: scene.coin.center.y),
                                          scale: min((frame.size.width/(scene.coin.radius*scale)) / 2, (frame.size.height/scene.coin.radius*scale) / 2))
        }

        // Draw table
        UIColor.brown.setFill()
        fillCircle(circle: scene.table)
        
        // Draw exits
        scene.exits.forEach({ exit in
            if exit === highlightedObject {
                UIColor.white.setFill()
            } else {
                UIColor.black.setFill()
            }
            fillCircle(circle: exit)
        })
        
        // Draw coin
        
        if scene.coin === highlightedObject {
            UIColor.white.setFill()
        } else {
            UIColor.yellow.setFill()
        }
        fillCircle(circle: scene.coin)
        
        // Draw obstacles
        scene.obstacles.forEach({ obstacle in
            if obstacle === highlightedObject {
                UIColor.white.setFill()
            } else {
                UIColor.blue.setFill()
            }
            fillCircle(circle: obstacle)
        })
        
        // Draw arrow
        if scene.isReadyToLaunch, let context = UIGraphicsGetCurrentContext(), let image = UIImage(named: "arrow2") {
            context.saveGState()
            
            // Use coin center
            let center = scenePosition.transform(point: scene.coin.center)
            context.translateBy(x: center.x, y: center.y)
            
            // Arrow angle
            let angle: CGFloat = PointTools.angle(scene.launchDirection)
            context.rotate(by: angle)
            context.translateBy(x: scenePosition.transform(radius: scene.coin.radius*1.25), y: 0.0)
            
            // Arrow scale
            context.scaleBy(x: scene.launchMagnitude, y: 1.0)
            
            // Define original image size
            let imageSize: CGSize = CGSize(width: 60.0, height: 20.0)
            
            // Define arrow image
            let imageFrame: CGRect = CGRect(x: 0, y: -imageSize.height*0.5, width: imageSize.width, height: imageSize.height)
            
            image.draw(in: imageFrame)
            context.restoreGState()
        }
    }
    
    private func fillCircle(circle: Circle) {
        let path = UIBezierPath(ovalIn: scenePosition.frame(forCircle: circle))
        path.fill()
    }
    
    func convertViewToSceneCoordinates(location: CGPoint) -> CGPoint {
        return scenePosition.backwardTransform(point: location)
    }
    
    func convertViewToSceneRadius(radius: CGFloat) -> CGFloat {
        return scenePosition.backwardTransform(radius: radius)
    }
    
}

// MARK: - Screen Position

fileprivate extension GameView {
    struct ScenePosition {
        
        var offset: CGPoint
        var center: CGPoint
        var scale: CGFloat
        
        func frame(forCircle circle: Circle) -> CGRect {
            let origin = transform(point: PointTools.substract(circle.center, circle.radius))
            return CGRect(x: origin.x,
                          y: origin.y,
                          width: 2 * circle.radius * scale,
                          height: 2 * circle.radius * scale)
        }
        
        func transform(point: CGPoint) -> CGPoint {
            return CGPoint(x: offset.x + (point.x-center.x) * scale,
                           y: offset.y + (point.y-center.y) * scale)
        }
        
        func backwardTransform(point: CGPoint) -> CGPoint {
            return CGPoint(x: (point.x - offset.x)/scale + center.x,
                           y: (point.y - offset.y)/scale + center.y)
        }
        
        func transform(radius: CGFloat) -> CGFloat {
            return radius*scale
        }
        
        func backwardTransform(radius: CGFloat) -> CGFloat {
            return radius/scale
        }
    }
}

// MARK: Camera Mode

extension GameView {
    enum CameraMode{
        case fullScene
        case followCoin(scale: CGFloat)
    }
}
