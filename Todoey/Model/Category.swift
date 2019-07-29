//
//  Category.swift
//  Todoey
//
//  Created by Luca Favaron on 29/07/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
