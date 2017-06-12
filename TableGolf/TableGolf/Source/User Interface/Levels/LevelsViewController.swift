//
//  LevelsViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

protocol LevelsDelegate: class {
    func didSelectLevel(sender: LevelsViewController, levelName: String, levelIndex: Int)
}

class LevelsViewController: UIViewController {

    public weak var delegate: LevelsDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var levels: [LevelData] = [LevelData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Level.initializeLevels()
        
        for i in Level.getAllLevels() {
            levels.append(LevelData(title: i.levelName))
        }
        
        setUpTableView()
    }
    
    private func setUpTableView() {
        guard let tableView = tableView else {
            return
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

}

extension LevelsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell", for: indexPath) as! LevelTableViewCell
        
        cell.levelData = levels[indexPath.row]
        return cell
    }
}

extension LevelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLevel(sender: self, levelName: levels[indexPath.row].title,levelIndex: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}

extension LevelsViewController {
    struct LevelData {
        var title: String
    }
}
