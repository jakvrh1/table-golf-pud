//
//  ViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var gameView: GameView?
    
    private var arrowStartLocation: CGPoint? = nil
    private var arrowCurrentLocation: CGPoint? = nil
    
    
// MARK: Game initialization
    
    private var scene: GameScene? = nil {
        didSet {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(withTutorialType: .basic)
        gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView?.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView?.setNeedsDisplay()
    }

// MAKR: Game gestures
    @objc private func onPanGesture(sender: UIGestureRecognizer){
        switch sender.state {
        case.began:
            arrowStartLocation = sender.location(in: gameView)
            gameView?.scene?.isReadyToLaunch = true
            
        case.changed:
            arrowCurrentLocation = sender.location(in: gameView)
            applyLaunchParameters()
            
            
        case.ended:
            arrowCurrentLocation = sender.location(in: gameView)
            applyLaunchParameters()
            
            gameView?.scene?.isReadyToLaunch = false
            
        default:
            break
        }
        gameView?.setNeedsDisplay()
    }
    
    private func applyLaunchParameters() {
        if let begin = arrowStartLocation, let current = arrowCurrentLocation {
            
            func scale(point: CGPoint, by scale: CGFloat) -> CGPoint {
                return CGPoint(x: point.x * scale, y: point.y * scale)
            }
    
            let scaleFactor: CGFloat = 10.0/min(view.frame.size.width, view.frame.size.height)
            gameView?.scene?.setLaunchParameters(withStartPoint: scale(point: begin, by: scaleFactor), endPoint: scale(point: current, by: scaleFactor))
        }
    }
}

