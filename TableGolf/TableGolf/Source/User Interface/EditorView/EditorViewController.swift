//
//  EditorViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

protocol EditorDelegate: class {
    func didSaveLevel(editor: EditorViewController, level: Level)
}

class EditorViewController: BaseViewController {

    @IBOutlet fileprivate var gameView: GameView?
    
    @IBOutlet private weak var sceneMenuPanel: UIView?
    
    @IBOutlet weak var bottomObjectMenuPanel: UIView?
    
    @IBOutlet weak var topObjectMenuPanel: UIView?
    
    @IBOutlet weak var bottomObjectMenuPanelBottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var topObjectMenuPanelTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet fileprivate weak var addElementPanelBottomConstraint: NSLayoutConstraint?
    
    weak var delegate: EditorDelegate?
    
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
    
    var selectedObject: Circle? = nil
    var startingLocation: CGPoint = CGPoint.zero
    var currentLocation: CGPoint = CGPoint.zero
    
    var scaleFactor:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if level == nil {
            level = Level(levelName: "", coin: Coin(withCenter: CGPoint.zero, andRadius: 4.0), table: Table(withCenter: CGPoint.zero, andRadius: 100.0), exits: [], obstacles: [])
        } else {
            gameView?.scene = scene
            gameView?.setNeedsDisplay()
        }
        
        gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture)))
        gameView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        
        gameView?.cameraMode = .fullScene
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onSave))
        
    }
    
    func onSave() {
        let controller: UIAlertController = UIAlertController(title: "Level name: ", message: "", preferredStyle: .alert)
        
        
        controller.addTextField { (text) in
            controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                if let level = self.level, let scene = self.scene {
                    level.levelName = text.text ?? "customLevel"
                    level.obstacles = scene.obstacles
                    level.exits = scene.exits
                    level.coin = scene.coin
                    level.table = scene.table
                    Level.saveLevel(level: level)
                    self.delegate?.didSaveLevel(editor: self, level: level)
                }
            }))
        }
        
        controller.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func onTap(sender: UIGestureRecognizer) {
        if mode == .scene {
            setMode(mode: .object, animated: true)
            if let gameView = gameView, let scene = scene {
                
                selectedObject = scene.firstObject(at: gameView.convertViewToSceneCoordinates(location: sender.location(in: gameView)),
                                                    radius: gameView.convertViewToSceneRadius(radius: 20.0))
                gameView.highlightedObject = selectedObject
            }
            
        } else {
            setMode(mode: .scene, animated: true)
            gameView?.highlightedObject = nil
            selectedObject = nil
        }
       
        gameView?.setNeedsDisplay()
    }
    
    @objc private func onPanGesture(sender: UIGestureRecognizer) {
        switch sender.state {
        case .began:
            startingLocation = sender.location(in: gameView)
        case .changed:
            currentLocation = sender.location(in: gameView)
            changeObjectLocation()
            startingLocation = sender.location(in: gameView)
        case .ended, .cancelled:
            currentLocation = sender.location(in: gameView)
            changeObjectLocation()
            startingLocation = sender.location(in: gameView)
        case .failed, .possible:
            break
        }
    }
    
    func setMode(mode: Mode, animated: Bool) {
        self.mode = mode
        switch mode {
        case .scene:
            addElementPanelBottomConstraint?.constant = 0
            topObjectMenuPanelTopLayoutConstraint?.constant = -(topObjectMenuPanel?.frame.size.height ?? 0)
            bottomObjectMenuPanelBottomLayoutConstraint?.constant = -(bottomObjectMenuPanel?.frame.size.height ?? 0)
        case .object:
            addElementPanelBottomConstraint?.constant = -(sceneMenuPanel?.frame.size.height ?? 0)
            topObjectMenuPanelTopLayoutConstraint?.constant = 0
            bottomObjectMenuPanelBottomLayoutConstraint?.constant = 0
            
            
        }
        
        UIView.animate(withDuration: animated ? 0.3 : 0) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func changeObjectLocation() {
        if let object = selectedObject, let gameView = gameView {
            let locationMovement = PointTools.substract(gameView.convertViewToSceneCoordinates(location: currentLocation), gameView.convertViewToSceneCoordinates(location: startingLocation))
            object.center = PointTools.sum(object.center, locationMovement)
            gameView.setNeedsDisplay()
        }
    }
    
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        scene?.table.radius = CGFloat(sender.value)
        gameView?.setNeedsDisplay()
    }
    
    
    @IBAction func onAddPressed(_ sender: Any) {
        let controller: UIAlertController = UIAlertController(title: "Add objects", message: "", preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (action) in
            self.gameView?.scene?.exits.append(Exit(withCenter: CGPoint.zero, andRadius: 30))
            self.gameView?.setNeedsDisplay()
        }))
        
        controller.addAction(UIAlertAction(title: "Obstacle", style: .default, handler: { (action) in
            self.gameView?.scene?.obstacles.append(Obstacle(withCenter: CGPoint.zero, andRadius: 30))
            self.gameView?.setNeedsDisplay()
        }))
        
        controller.addAction(UIAlertAction(title: "Cancle", style: .default, handler: { (action) in
        }))

        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func onDeletePressed(_ sender: Any) {
        if let coin = selectedObject as? Coin {
            return
        }
        
        let controller: UIAlertController = UIAlertController(title: "Are you sure you want to delete this object?", message: "", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if let object = self.selectedObject {
                self.scene?.removeObject(object: object)
            }
            self.selectedObject = nil
            self.gameView?.setNeedsDisplay()
        }))
        
        controller.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func onCancelPressed(_ sender: Any) {
        setMode(mode: .scene, animated: true)
        
        gameView?.highlightedObject = nil
        selectedObject = nil
        gameView?.setNeedsDisplay()
    }
    
    
    @IBAction func isObjectSliderChanged(_ sender: UISlider) {
        
        if let object = selectedObject {
            object.radius = CGFloat(sender.value)
        }
        gameView?.setNeedsDisplay()
    }
}

extension EditorViewController {
    enum Mode {
        case scene
        case object
    }
}
