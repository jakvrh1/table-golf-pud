//
//  Table.swift
//  TableGolf
//
//  Created by Jaka on 6/5/17.
//  Copyright © 2017 Jaka. All rights reserved.
//

import UIKit

class Table: Circle {
    
    func duplicate() -> Table {
        return Table(withCenter: self.center, andRadius: self.radius)
    }
    
}
