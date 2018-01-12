//
//  Caegory.swift
//  Todoey
//
//  Created by Shadab Khan on 1/11/18.
//  Copyright © 2018 Shadab Khan. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name :String = ""
        let items = List<Item>()
}
