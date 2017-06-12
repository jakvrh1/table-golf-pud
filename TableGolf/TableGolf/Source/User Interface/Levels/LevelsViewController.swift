//
//  LevelsViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

protocol LevelsDelegate: class {
    func didSelectLevel(sender: LevelsViewController, level: Level)
}

class LevelsViewController: BaseViewController {

    public weak var delegate: LevelsDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var levels: [Level] = [Level]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Level.initializeLevels()
        
        levels = Level.getAllLevels()
        
        
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
        
        cell.level = levels[indexPath.row]
        return cell
    }
}


extension LevelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLevel(sender: self, level: levels[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Cell data
extension LevelsViewController {
    struct LevelData {
        var title: String
    }
}
