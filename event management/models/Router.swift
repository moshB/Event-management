//
//  Router.swift
//  event management
//
//  Created by Mosh on 16/02/2021.
//

import UIKit
import FirebaseAuth

//class since we use it everyehere in our app -> singleton
class Router{
    
    var eventId:String?
    //singleton:
    static let shared = Router()
    
    //properties:
    weak var window: UIWindow?
    var isAuthorized: Bool {
         Auth.auth().currentUser != nil
    }
 
    //init:
    private init(){}
    
    //methods:
    func determineRootViewController(){
        let name = isAuthorized ? "Main" : "Login"
        let storyboard = UIStoryboard(name: name, bundle: .main)
        let rootViewContoller = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = rootViewContoller
    }
    func eventMenagerViewController(name:String){
        let storyboard = UIStoryboard(name: name, bundle: .main)
        let rootViewContoller = storyboard.instantiateInitialViewController()
        window?.rootViewController = rootViewContoller
    }
}
