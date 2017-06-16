//
//  AlertView.swift
//  TableGolf
//
//  Created by Jaka on 6/15/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class AlertView {

    static func showMessage(message: String, forDuration duration: TimeInterval, inController controller: UIViewController) {
        let alert = UIAlertController(title: "", message: "Coin cant be in exit", preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    static func showTextInput(title: String?, message: String?, textFieldText: String? = nil, inController controller: UIViewController, completion: @escaping (_ text: String)->Void) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { field in
            field.text = textFieldText
        }
        
        alertController.addAction(UIAlertAction(title: "Go", style: .default, handler: { action in
            
            let inputText = alertController.textFields?.first?.text
            completion(inputText ?? "")
            
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
            let inputText = alertController.textFields?.first?.text
            completion(inputText ?? "")
            
        }))
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showConfirmation(title: String?, message: String?, inController controller: UIViewController, completion: @escaping (_ text: Bool)->Void) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            completion(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            completion(false)
        }))
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
