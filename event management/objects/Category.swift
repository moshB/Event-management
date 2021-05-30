//
//  Category.swift
//  event management
//
//  Created by Mosh on 20/02/2021.
//

import UIKit


class Category{
    let id: String
    let name:String
    var tasks:[String: Task] = [:]
    //    let color:UIColor?
    var dictTasks:[String:[String:Any]]{
        var myTasks:[String:[String:Any]] = [:]
        for (id, task) in tasks{
            myTasks[id] = ["id": task.id, "name": task.name, "note": task.note, "budget": task.budget, "done": task.done]
        }
        return myTasks
    }
    var dict:[String:Any]{
        ["id": id, "name": name, "tasks": dictTasks]
    }
    init(name:String,  tasks:[String: Task]) {
        id = UUID().uuidString
        self.name = name
        self.tasks = tasks
        //        self.color = color
    }
    required init?(dict:[String:Any]){
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String
        //              let color = dict["color"] as? UIColor,
        //              let tasks = dict["tasks"] as? [String: Task]
        else {return nil}
        self.id = id
        self.name = name
        //        self.color = color
        if let tasks = dict["tasks"] as? [String:Any]{
            for (key, value) in tasks {
                if let value = value as? [String:Any]{
                    let task = Task(dict: value)
                    self.tasks[key] = task
                }
            }
        }
    }
}
