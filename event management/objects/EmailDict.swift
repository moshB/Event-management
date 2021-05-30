//
//  EmailDict.swift
//  event management
//
//  Created by Mosh on 20/02/2021.
//

import Foundation
class EmailDict{
    let email:String?
    let uid:String?
    init(email: String, uid: String) {
        self.email = IO.getStringFromEmail(email: email)
        self.uid = uid
    }
    init(){
        self.email = nil
        self.uid = nil
    }
}
