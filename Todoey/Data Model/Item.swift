//
//  Item.swift
//  Todoey
//
//  Created by Shadab Khan on 1/11/18.
//  Copyright © 2018 Shadab Khan. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var tittle : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
