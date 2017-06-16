//
//  MenuViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/9/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit
import MessageUI

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
    
    
    // If file sharedLevel.cdl exists save it to Level.allLevels
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.path {
            let path = dir + "/sharedLevel.cdl"
            
            if FileManager.default.fileExists(atPath: path) {
                
                let levels = Level.deserializeDataFromJSON(url: URL(fileURLWithPath: path))
                Level.addLevels(levels: levels)
                Level.saveAll()
                
                try? FileManager.default.removeItem(atPath: path)
            }
        }
        
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
    
    @IBAction func shareLevel(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Email not available at the moment!")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface
        composeVC.setToRecipients(["jakvrh1@gmail.com"])
        composeVC.setSubject("Table Golf level \(selectedLevel?.name ?? "" )")
        composeVC.setMessageBody("Try out my level!", isHTML: false)
        
        if let level = selectedLevel {
            Level.serializeDataIntoJSON(levels: [level], path: .level)
            
            composeVC.addAttachmentData(Level.levelData(level: level), mimeType: "cdl", fileName: "Level.cdl")
        }
        
        // Present the view controller modally
        self.present(composeVC, animated: true, completion: nil)
    }
  
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
