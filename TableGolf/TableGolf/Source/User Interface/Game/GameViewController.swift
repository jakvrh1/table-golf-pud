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
    
    @IBOutlet weak private(set) var numberOfMovesLabel: UILabel!
 
    private var arrowStartLocation: CGPoint? = nil
    private var arrowCurrentLocation: CGPoint? = nil
    private var scaleFactor: CGFloat = 1.0
    
    public var selectedLevel: Int = 0
    
    // MARK: Game initialization
    fileprivate var scene: GameScene? = nil {
        didSet {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
            scene?.delegate = self
        }
    }
//    
//    convenience init(levelIndex index: Int) {
//        self.init()
//        self.selectedLevel = index
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(levelNumber: selectedLevel)
        gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))
        //gameView?.cameraMode = .followCoin(scale: 10.0)
        gameView?.cameraMode = .fullScene

        popupLevelName()
    }
    
    func popupLevelName() {
        let alert = UIAlertController(title: "", message: scene?.levelName, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
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
            
            if let crLvl = self.scene?.currentLevel {
                self.scene = GameScene(levelNumber: crLvl)
                self.popupLevelName()
            }
            
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
    
    func gameSceneDidChangeNumberOfMoves(sender: GameScene, to numberOfMoves: Int) {
        numberOfMovesLabel.text = "Moves: \(numberOfMoves)"
    }

}

