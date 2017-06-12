//
//  EditorViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class EditorViewController: BaseViewController {

    @IBOutlet fileprivate var gameView: GameView?
    
    @IBOutlet private weak var sceneMenuPanel: UIView?
    
    @IBOutlet fileprivate weak var addElementPanelBottomConstraint: NSLayoutConstraint?
    
    private var mode: Mode = .scene
    
    override var allowsPopupGesture: Bool {
        return false
    }
    
    var level: Level? {
        didSet {
            if let level = level {
                scene = GameScene(level: level)
            } else {
                scene = nil
            }
            
        }
    }
    
    fileprivate var scene: GameScene? = nil {
        didSet {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
        }
    }
    
    var scaleFactor:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if level == nil {
            level = Level(levelName: "", coin: Coin(withCenter: CGPoint.zero, andRadius: 4.0), table: Table(withCenter: CGPoint.zero, andRadius: 100.0), exits: [], obstacles: [])
        } else {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
        }
        
        /*gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))*/
        gameView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        
        gameView?.cameraMode = .fullScene
        
    }
    
    @objc private func onTap(sender: UIGestureRecognizer) {
        
        if mode == .scene {
            setMode(mode: .object, animated: true)
        } else {
            setMode(mode: .scene, animated: true)
        }
        
        
        if let locationInScene = gameView?.convertViewToSceneCoordinates(location: sender.location(in: gameView)) {
            print(locationInScene)
        }
       
        gameView?.setNeedsDisplay()
    }
    
    /*@objc private func onPanGesture(sender: UIGestureRecognizer) {
        switch sender.state {
        case .began:
            
        case .changed:
            
        case .ended, .cancelled:
            
        case .failed, .possible:
            break
        }
        gameView?.setNeedsDisplay()
    }*/
    
    func setMode(mode: Mode, animated: Bool) {
        self.mode = mode
        switch mode {
        case .scene:
            addElementPanelBottomConstraint?.constant = 0
        case .object:
            addElementPanelBottomConstraint?.constant = -(sceneMenuPanel?.frame.size.height ?? 0)
        }
        
        UIView.animate(withDuration: animated ? 0.3 : 0) { 
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        scene?.table.radius = CGFloat(sender.value)
        gameView?.setNeedsDisplay()
    }
    
    
    @IBAction func onAddPressed(_ sender: Any) {
        
    }
    

}

extension EditorViewController {
    enum Mode {
        case scene
        case object
    }
}
