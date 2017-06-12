//
//  Obstacle.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Obstacle: Circle {

    func duplicate() -> Obstacle {
        return Obstacle(withCenter: self.center, andRadius: self.radius)
    }
    
}
