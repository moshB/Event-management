//
//  Event.swift
//  event management
//
//  Created by Mosh on 19/02/2021.
//

import Foundation

class Event{
    let id:String    
    var name:String
    var typeEvent:String
    var budget:Int
    var dateEvent:Date
    let createdAt:Date
    var imageUrl:String?
    
    var eventPartner:[String:String]?
    var eventAsk:[String:String]?
    var categorys:[String: Category] = [:]
    
    var dict: [String : Any] {
        var dict: [String: Any] = ["id":id, "name": name, "typeEvent":typeEvent, "budget": budget]
        dict["createdAt"] = IO.formatter.string(from: createdAt)
        dict["dateEvent"] = IO.formatter.string(from: dateEvent)
        
        if let imageUrl = imageUrl{
            dict["imageUrl"] = imageUrl
        }
        if let eventPartner = eventPartner{
            dict["eventPartner"] = eventPartner
        }
        if let eventAsk = eventAsk{
            dict["eventAsk"] = eventAsk
        }
            dict["categorys"] = dictCategory
        
        return dict
    }
    var dictCategory:[String:[String:Any]]{
        var myCategory:[String:[String:Any]] = [:]
        for (id, category) in categorys {
            myCategory[id] = ["id": category.id, "name": category.name, "tasks": category.tasks]
        }
        return myCategory
    }
    init(name:String, typeEvent:String, budget:Int, dateEvent:Date) {
        id = UUID().uuidString
        createdAt = Date()//now
        
        self.name = name
        self.typeEvent = typeEvent
        self.budget = budget
        self.dateEvent = dateEvent
        
        self.eventPartner = [IO.getUid(): IO.getNickName()]
        
    }
    init(){
        self.id = ""
        self.name = ""
        self.typeEvent = ""
        self.budget = 0
        self.dateEvent = Date()
        self.createdAt = dateEvent
    }
    required init?(dict: [String: Any]) {
        guard
            let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let typeEvent = dict["typeEvent"] as? String,
            let budget = dict["budget"] as? Int,
            let dateEventString = dict["dateEvent"] as? String,
            let dateEvent = IO.formatter.date(from: dateEventString),
            let createdAtString = dict["createdAt"] as? String,
            let createdAt = IO.formatter.date(from: createdAtString)        
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.typeEvent = typeEvent
        self.budget = budget
        self.dateEvent = dateEvent
        self.createdAt = createdAt
        
        self.imageUrl = dict["imageUrl"] as? String
        self.eventPartner = dict["eventPartner"] as? [String:String]
        self.eventAsk = dict["eventAsk"] as? [String:String]
        if let categorys = dict["categorys"] as? [String:Any]{
           
            for (key, value) in categorys {
                if let value = value as? [String:Any]{
                    if let category = Category(dict: value){
                        self.categorys[key.description] = category
                       
                    }
                }
            }
        }       
    }
}
