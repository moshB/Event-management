//
//  FirebaseDB.swift
//  event management
//
//  Created by Mosh on 19/02/2021.
//

import FirebaseDatabase

class FirebaseDB{
    
    
    private init(){/*No instances from outside theclass (PRIVATE)*/}
    static let sharedFBDB = FirebaseDB()
    
    
    static var eventsRef: DatabaseReference{
        return Database.database().reference().child("events")
    }
    static var usersRef: DatabaseReference{
        return Database.database().reference().child("users")
    }
    static var emailsDBRef: DatabaseReference{
        return Database.database().reference().child("emails")
    }
    
}
