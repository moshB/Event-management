//
//  Task.swift
//  event management
//
//  Created by Mosh on 20/02/2021.
//

import Foundation

class Task{
    let id:String
    let name:String
    let note:String
    let budget:Int
    var done:Bool
    
    init(name: String, note:String = "", budget:Int = 0, done:Bool = false){
        id = UUID().uuidString
        self.name = name
        self.note = note
        self.budget = budget
        self.done = done
    }
    init(id: String, name: String, note:String = "", budget:Int = 0, done:Bool = false){
        self.id = id
        self.name = name
        self.note = note
        self.budget = budget
        self.done = done
    }
    var dict:[String:Any]{
        ["id": id, "name": name, "note": note, "budget": budget, "done": done]
    }
    required init?(dict:[String:Any]){
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let note = dict["note"] as? String,
              let budget = dict["budget"] as? Int,
              let done = dict["done"] as? Bool
        else {return nil}
        self.id = id
        self.name = name
        self.note = note
        self.budget = budget
        self.done = done
    }

    
}
