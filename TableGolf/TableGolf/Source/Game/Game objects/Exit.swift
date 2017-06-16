//
//  Exit.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Exit: Circle {

    func duplicate() -> Exit {
        return Exit(withCenter: self.center, andRadius: self.radius)
    }
    
}
