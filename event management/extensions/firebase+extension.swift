//
//  firebase+extension.swift
//  event management
//
//  Created by Mosh on 19/02/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

//MARK:- extension User

extension User{
    
    static var user:User = User()
    
    
    static var ref: DatabaseReference{
        return Database.database().reference().child("users")
    }
    
    
    func start(callback: @escaping (Error?, Bool)->Void){
        User.ref.child(IO.getUid()).child("nickName").setValue(nickName) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
        }
        EmailDict(email: IO.getEmail(), uid: IO.getUid()).addEmail(callback: callback)
    }
    
    func addEventToUser(uid:String,eventId : String,eventName:String, callback: @escaping (Error?, Bool)->Void) {
        User.ref.child(uid).child("events/\(eventId)").setValue(eventName) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
    // delete the id of event from the user with callback
    func deleteEventFromUser(uid:String,eventId : String, callback: @escaping (Error?, Bool)->Void) {
        User.ref.child(uid).child("events/\(eventId)").removeValue{ (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
        
    
    }
    
    // get dictionary from firebase of events
    func getMyEvents(callback: @escaping (Error?, [String:String]?)->Void) {
        var dict:[String:String]?
        User.ref.child(IO.getUid()).child("events").observeSingleEvent(of: DataEventType.value) { (snapshot) in            
            dict = snapshot.value as? [String:String]
            callback(nil, dict)
        } withCancel: { (err) in
            callback(err, dict)
        }
        
    }
    func getUserNickName(uid:String, callback: @escaping (Error?, String?)->Void) {
        var nickName:String?
        User.ref.child(uid).child("nickName").observe(.value) { (snap) in
            nickName = snap.value as? String
            callback(nil, nickName)
        }withCancel: { (err) in
            callback(err, nickName)
        }
    }
    
    
    //todo edit name event
    
    
}

//MARK:- extension EmailDict

extension EmailDict{
    static var ref: DatabaseReference{
        return Database.database().reference().child("emails")
    }
    
    func addEmail(callback: @escaping (Error?, Bool)->Void){
        guard let email = self.email,
              let uid = self.uid else {
            callback(ErrorData.noEmailDict, false)
            return
        }
        EmailDict.ref.child(email).setValue(uid) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
    
    
    func getUserUid(email:String, callback: @escaping (Error?, String?)->Void) {
        let email = IO.getStringFromEmail(email: email)
        var uid:String?
        EmailDict.ref.child(email).observe(.value) { (snap) in
            uid = snap.value as? String
            callback(nil, uid)
        } withCancel: { (err) in
            callback(err, uid)
        }
    }
 
}

//MARK:- extension Event

extension Event: ShowHUD{
    
    static var event:Event = Event()
    
    var ref: DatabaseReference{
        return Database.database().reference().child("events")
    }
    var storageRef: StorageReference{
        return Storage.storage().reference().child("events").child("\(id).jpg") //products/0340fsd0fs-sdf0sf0sf0fs.jpg
    }
    
    func addUserToEvent(email: String, callback: @escaping (Error?, Bool, String, String)->Void){
        let email = IO.getStringFromEmail(email: email)
        EmailDict().getUserUid(email: email) { (err, uid) in
            if let err = err{
                callback(err, false, "", "")
            }
            if let uid = uid{
                User.user.getUserNickName(uid: uid) { (err, nickName) in
                    if let err = err{
                        callback(err, false, "", "")
                    }
                    if let nickName = nickName{
                        Event.event.ref.child(self.id).child("eventPartner").child(uid).setValue(nickName) { (err, dbRef) in
                            if let error = err{
                                callback(error, false, "", "")
                                return
                            }
                            callback(nil, true, uid, nickName)
                        }
                    }
                }
            }else{
                callback(ErrorData.noUser, true, "", "")
            }
        }
    }
    
    //save event data in firebase
    func save(callback: @escaping (Error?, Bool)->Void){
        Event.event.ref.child(id).setValue(dict) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
        }
        User(nickName: IO.getNickName()).addEventToUser(uid: IO.getUid(),
                                                        eventId: id,
                                                        eventName: name,
                                                        callback: callback)
        
    }
    //save event storge in firebase
    func save(image: UIImage, callback: @escaping (Error?, Bool)->Void){
        //save the image to the storage:
        //1)serialize the image to binary
        guard let data = image.jpegData(compressionQuality: 1) else {
            callback(nil, false)
            return
        }
        
        //2)upload the image ->
        storageRef.putData(data, metadata: nil) {[weak self] (metadata, err) in
            if let err = err{
                callback(err, false)
                return
            }
            guard let self = self else{
                return
            }
            self.imageUrl = "\(self.id).jpg"
            //2.1) upload the record to the database
            self.save(callback: callback)
        }
    }
    
  
    
    
    //edit event data in firebase
    func edit(callback: @escaping (Error?, Bool)->Void){
        Event.event.ref.child(id).child("name").setValue(name) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }

        }
        Event.event.ref.child(id).child("typeEvent").setValue(typeEvent) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
        }
        Event.event.ref.child(id).child("budget").setValue(budget) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
        }
        Event.event.ref.child(id).child("dateEvent").setValue(IO.formatter.string(from: dateEvent)) { (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
        }
        callback(nil, true)

    }

    
    
    
    
    //edit event storge in firebase
    func edit(image: UIImage, callback: @escaping (Error?, Bool)->Void){
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            callback(nil, false)
            return
        }
        
        storageRef.putData(data, metadata: nil) {[weak self] (metadata, err) in
            if let err = err{
                callback(err, false)
                return
            }
            guard let self = self else{
                return
            }
            self.imageUrl = "\(self.id).jpg"
            self.edit(callback: callback)
        }
    }
    
    //add category to firebase
    func addCategory(category:Category, callback: @escaping (Error?, Bool)->Void){
        
        Database.database().reference().child("events").child(id)
            .child("categorys")
            .child(category.id)
            .setValue(category.dict)
            {(err, dbRef) in
                if let error = err{
                    callback(error, false)
                    return
                }
                callback(nil, true)
            }
    }
    //add task to firebase
    func addTask(task:Task,categoryId:String, callback: @escaping (Error?, Bool)->Void) {
        
        Event.event.ref.child(id).child("categorys").child(categoryId).child("tasks").child(task.id).setValue(task.dict){ (err, dbRef) in
            if let error = err{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
    //callback design pattern to get event from firebase or getting ErrorData
    func getEvent(callback: @escaping (Error?, Event?)->Void){
        
        guard let eId = Router.shared.eventId else {
            callback(ErrorData.noEventId, nil)
            return
        }
        Event.event.ref.child(eId)
            .getData { (err, snapshot) in
                if let err = err{
                    callback(err, nil)
                    return
                }
                
                guard let dict = snapshot.value as? [String : Any],
                      let event = Event(dict: dict) else{
                    callback(ErrorData.errorDecodingData, nil)
                    return
                }
                callback(nil, event)
                
            }    }
    
    //edit task data in firebase
    func editTask(idCateg:String,  task:Task?, idTask:String?,isFinish:Bool?, callback: @escaping (Error?, Bool)->Void){
        
        if let idTask = idTask, let isFinish = isFinish{
            Event.event.ref.child(id).child("categorys").child(idCateg).child("tasks")
                .child(idTask)
                .child("done")
                .setValue(isFinish) { (err, dbRef) in
                    if let err = err{
                        callback(err, false)
                        return
                    }
                    callback(nil, true)
                }
        }
        guard let task = task else {
            callback(ErrorData.taskError, false)
            return
        }
        
        Event.event.ref
            .child(id)
            .child("categorys")
            .child(idCateg)
            .child("tasks")
            .child(task.id)
            .setValue(task.dict) { (err, dbRef) in
                if let err = err{
                    callback(err, false)
                }
                callback(nil, true)
            }
    }
    
    
    // delete task data in firebase
    func deleteTask(idCateg:String, idTask:String){
        Event.event.ref.child(id).child("categorys").child(idCateg).child("tasks")
            .child(idTask).removeValue()
    }
    // delete category data in firebase
    func deleteCategory(idCateg:String){
        Event.event.ref.child(id).child("categorys").child(idCateg).removeValue()
    }
    // delete user data in firebase with callback
    func deleteUserFromEvent(idUser:String,  callback: @escaping (Error?, Bool)->Void){
        Event.event.ref.child(id)
            .child("eventPartner")
            .child(idUser)
            .removeValue { (err, dbRef) in
            if let err = err{
                callback(err, false)
            }
            callback(nil, true)
        }
    }
    // delete event with all the data from firebase
    func deleteEvent(callback: @escaping (Error?, Bool)->Void){
        User.user.deleteEventFromUser(uid: IO.getUid(), eventId: id) { (err, bool) in
            self.storageRef.delete { [self] (err) in
                if let err = err{
                    callback(err, false)
                }
                ref.child(id).removeValue { (err, dbRef) in
                    if let err = err{
                        callback(err, false)
                    }
                    callback(nil, true)
                }
            }
        }
    }
}

//MARK:- enum Error

enum ErrorData: String, Error {
    case taskError
    case noEmailDict = "Propertys of EmailDict no initialize"
    case noEventId = "Error Try closing the app and reopening"
    case errorDecodingData = "Error Decoding Data"
    case noUser = "There is no user for the requested email"
}
