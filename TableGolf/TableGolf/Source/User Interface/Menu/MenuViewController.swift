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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func playGameScene(_ sender: Any) {
        let controller = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameViewController")
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    


}
