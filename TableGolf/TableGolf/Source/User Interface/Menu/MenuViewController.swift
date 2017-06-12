//
//  MenuViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var editLevelButton: UIButton!
    @IBOutlet weak var newLevelButton: UIButton!
    @IBOutlet weak var selectLevelButton: UIButton!
    
    fileprivate var selectedLevel: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playGameScene(_ sender: Any) {
        let controller: GameViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        controller.selectedLevel = selectedLevel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func selectLevel(_ sender: Any) {
        let controller: LevelsViewController = UIStoryboard(name: "Levels", bundle: nil).instantiateViewController(withIdentifier: "LevelsViewController") as!LevelsViewController
        
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MenuViewController: LevelsDelegate {
    func didSelectLevel(sender: LevelsViewController, levelName: String, levelIndex: Int) {
        label.text = levelName
        selectedLevel = levelIndex
    }
}
