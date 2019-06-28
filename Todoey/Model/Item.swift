//
//  Item.swift
//  Todoey
//
//  Created by Luca Favaron on 26/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import Foundation

class Item: Encodable {
    var title : String = ""     // nome elemento lista
    var done : Bool = false     // check di spunta
}
