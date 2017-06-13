//
//  BaseViewController.swift
//  TableGolf
//
//  Created by Jaka on 6/12/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

// Base class to disable interactive pop gesture recognizer

class BaseViewController: UIViewController {

    var allowsPopupGesture: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = allowsPopupGesture
    }
    
}
