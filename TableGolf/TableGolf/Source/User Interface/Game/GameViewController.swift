//
//  GameViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet fileprivate weak var gameView: GameView?
    
    private var arrowStartLocation: CGPoint? = nil
    private var arrowCurrentLocation: CGPoint? = nil
    private var scaleFactor: CGFloat = 1.0
    
    // MARK: Game initialization
    fileprivate var scene: GameScene? = nil {
        didSet {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
            scene?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(withTutorialType: .basic)
        gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))
        gameView?.cameraMode = .fullScene
        
        
        
        let controller: UIAlertController = UIAlertController(title: scene?.levelName, message: "", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) in
         
        }))
        
        present(controller, animated: true, completion: nil)


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

// MARK: GameScene delegate

extension GameViewController: GameSceneDelegate {
    
    func closeCurrentViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func gameSceneDidFinishWithVictory(sender: GameScene) {
        let controller: UIAlertController = UIAlertController(title: "You win!", message: "You advance to next lvl", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Next lvl", style: .default, handler: { (action) in
            self.scene = GameScene(withTutorialType: .lvl1)
        }))
        
        present(controller, animated: true, completion: nil)
    }
    
    func gameSceneDidFinishWithLose(sender: GameScene) {
        let controller: UIAlertController = UIAlertController(title: "You lost!", message: "Try again", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Return to menu", style: .default, handler: { (action) in
            self.closeCurrentViewController()
        }))
        
        present(controller, animated: true, completion: nil)
    }
    
    func gameSceneNeedsRefresh(sender: GameScene) {
        gameView?.setNeedsDisplay()
    }
    
    func gameSceneDidCollide(sender: GameScene) {
    }
}

