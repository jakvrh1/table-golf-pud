//
//  LevelTableViewCell.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    @IBOutlet weak var levelNameLabel: UILabel!
    
    var levelData: LevelsViewController.LevelData? {
        didSet {
            levelNameLabel?.text = levelData?.title
        }
    }
    

    

}
