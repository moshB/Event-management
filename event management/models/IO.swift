//
//  IO.swift
//  event management
//
//  Created by Mosh on 19/02/2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
class IO  {
    
    static func getUid()->String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    static func getEmail()->String {
        return Auth.auth().currentUser?.email ?? ""
    }
    static func getNickName()->String {
        Auth.auth().currentUser?.displayName ?? ""
    }
    static func getEmailFromString(string:String)->String {
        return string.replacingOccurrences(of: "____", with: ".")
    }
    static func getStringFromEmail(email:String)->String {
        return email.replacingOccurrences(of: ".", with: "____")
    }
    
   
    
    
    static var formatter: ISO8601DateFormatter{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        return formatter
    }
    
    static var formatDate: ISO8601DateFormatter{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }
    static var formatDay: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE hh:mm"
        return formatter
    }
    
    static var formatDouble: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    

}
