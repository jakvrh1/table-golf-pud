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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView?.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView?.setNeedsDisplay()
    }


}

