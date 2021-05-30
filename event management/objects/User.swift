//
//  User.swift
//  event management
//
//  Created by Mosh on 19/02/2021.
//

import Foundation

class User{
    
    let nickName:String
    let events:[String:String]?
    
    init(nickName:String, events:[String:String] = [:]) {
        self.nickName = nickName
        self.events = events
    }
    init(){
        self.nickName = IO.getNickName()
        self.events = nil
    }
    
    
}
