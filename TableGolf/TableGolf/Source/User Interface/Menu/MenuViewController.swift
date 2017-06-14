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
        selectedLevel = Level.allLevels.first
        label.text = Level.allLevels.first?.name ?? "No levels"
    }

    // GameViewController
    @IBAction func playGameScene(_ sender: Any) {
        let controller: GameViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        controller.level = selectedLevel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // EditorViewController
    @IBAction func editLevel(_ sender: Any) {
        let controller: EditorViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        controller.level = selectedLevel
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // NewLevel - EditorViewController
    @IBAction func newLevel(_ sender: Any) {
        let controller: EditorViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // LevelsViewController
    @IBAction func selectLevel(_ sender: Any) {
        let controller: LevelsViewController = UIStoryboard(name: "Levels", bundle: nil).instantiateViewController(withIdentifier: "LevelsViewController") as!LevelsViewController
        
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension MenuViewController: LevelsDelegate {
    // Changes label text to selected level
    func didSelectLevel(sender: LevelsViewController, level: Level) {
        label.text = level.name
        selectedLevel = level
    }
}

extension MenuViewController: EditorDelegate {
    // Changes label text to saved level
    func didSaveLevel(editor: EditorViewController, level: Level) {
        self.selectedLevel = level
        self.label.text = level.name
    }
}
