//
//  MenuViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var editLevelButton: UIButton!
    @IBOutlet weak var newLevelButton: UIButton!
    @IBOutlet weak var selectLevelButton: UIButton!
    
    fileprivate var selectedLevel: Level?

    override func viewDidLoad() {
        super.viewDidLoad()
        Level.initializeLevels()
        selectedLevel = Level.getAllLevels()[0]
        label.text = Level.getAllLevels()[0].levelName
    }

    @IBAction func playGameScene(_ sender: Any) {
        let controller: GameViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        controller.level = selectedLevel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func editLevel(_ sender: Any) {
        let controller: EditorViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        controller.level = selectedLevel
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func newLevel(_ sender: Any) {
        let controller: EditorViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func selectLevel(_ sender: Any) {
        let controller: LevelsViewController = UIStoryboard(name: "Levels", bundle: nil).instantiateViewController(withIdentifier: "LevelsViewController") as!LevelsViewController
        
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MenuViewController: LevelsDelegate {
    func didSelectLevel(sender: LevelsViewController, level: Level) {
        label.text = level.levelName
        selectedLevel = level
    }
}
