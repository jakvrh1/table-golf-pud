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
    private var scaleFactor: CGFloat = 1.0
    
    // MARK: Game initialization
    
    private var scene: GameScene? = nil {
        didSet {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(withTutorialType: .lvl1)
        gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))
        gameView?.cameraMode = .fullScene
        
        let displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    @objc func onDisplayLink() {
        scene?.move(dt: 1.0/60.0)
        gameView?.setNeedsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView?.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView?.setNeedsDisplay()
        
        scaleFactor = 2.0/min(view.frame.size.width, view.frame.size.height)
    }
    
    // MARK: Game gestures
    @objc private func onPanGesture(sender: UIGestureRecognizer) {
        guard scene?.canLaunch == true else {
            return
        }
        
        switch sender.state {
        case .began:
            arrowStartLocation = sender.location(in: gameView)
        case .changed:
            arrowCurrentLocation = sender.location(in: gameView)
            applyLaunchParameters()
        case .ended, .cancelled:
            arrowCurrentLocation = sender.location(in: gameView)
            applyLaunchParameters()
            scene?.launch()
        case .failed, .possible:
            break
        }
        gameView?.setNeedsDisplay()
    }
    
    private func applyLaunchParameters() {
        if let begin = arrowStartLocation, let current = arrowCurrentLocation {
            gameView?.scene?.setLaunchParameters(withStartPoint: PointTools.scale(point: begin, by: scaleFactor), endPoint: PointTools.scale(point: current, by: scaleFactor))
        }
    }
}

