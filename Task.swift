//
//  Task.swift
//  taskapp
//
//  Created by 田村尚利 on 2018/11/13.
//  Copyright © 2018 masatoshi.tamura. All rights reserved.
//

//import Foundation

import RealmSwift

class Task: Object{
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
    
    override static func primaryKey() -> String{
        return "id"
        
    }
}
