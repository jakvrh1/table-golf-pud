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
    
    @IBOutlet weak var tableView: UITableView?
    
    var levels: [Level] = [Level]()
    
    
//MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Level.deserializeDataFromJSON()
        levels = Level.allLevels
        
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

//MARK: UITableView properties

extension LevelsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell", for: indexPath) as! LevelTableViewCell
        
        cell.level = levels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Level.removeLevel(index: indexPath.row)
            levels = Level.allLevels
            self.tableView?.reloadData()
        }
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
