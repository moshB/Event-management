//
//  RegisterViewController.swift
//  event management
//
//  Created by Mosh on 16/02/2021.
//

import UIKit

import FirebaseAuth

class RegisterViewController: UIViewController {

    var user:User?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!    
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    
    @IBAction func register(_ sender: UIButton) {
        
        guard let email = emailTextField.text, isEmailValid,
              let password = passwordTextField.text, isPasswordValid,
              var nickName = nickNameTextField.text
              else {
              return
        }
        //if nick is empty -> nick = email
        nickName = nickName.count > 0 ? nickName : email.components(separatedBy: "@")[0]
        user = User(nickName: nickName)
        //start the auth proccess:
        sender.isEnabled = false //can't click Register 2 times in a row
        showProgress(title: "Please Wait")

        Auth.auth().createUser(withEmail: email,
                               password: password) {[weak self] (result, err) in
            if let err = err{
                self?.showError(title: err.localizedDescription)
                sender.isEnabled = true
                return
            }

            guard let user = result?.user else {
                self?.showError(title: "No User")
                sender.isEnabled = true
                return
            }
            
             //user profile additional info:
            let profileChangeReqeust = user.createProfileChangeRequest()
            profileChangeReqeust.displayName = nickName
            
            profileChangeReqeust.commitChanges { (error) in
                if let error = error {
                    //change name failed
                    self?.showError(title: "Nick name not set",
                                    subtitle: error.localizedDescription)
                    sender.isEnabled = true
                }else {
                    self?.startDatabaseUser(sender)
                }
            }
        }
    }
    
    func startDatabaseUser(_ sender: UIButton){
        func saveUserCallback(_ error: Error?, _ success: Bool){
            sender.isEnabled = true
            if success {
                self.showSuccess(title: "Done!")
                //pop back to the tableview controller
                Router.shared.determineRootViewController()
            }else {
                showError(title: "Please try again")
                Auth.auth().currentUser?.delete(completion: { (err) in
                    self.showError(title: "Error user start whit out nickName")
                })
                sender.isEnabled = true
            }
            user = nil //manual memory managment
        }
        user?.start(callback: saveUserCallback(_:_:))
    }
    
  
    
    
}



//user validation in our project:
//in addition to HUD
protocol UserValidation: ShowHUD {
    //1) you must have a TextField called emailTextField
    var emailTextField: UITextField!{get}
    var passwordTextField: UITextField!{get}
}

//client side validation
extension UserValidation{
    
    var isEmailValid: Bool{
        //professional code for email checking
        guard emailTextField.isEmail() else {
            showError(title: "Email must be valid")
            return false
        }
        return true
    }
    
    var isPasswordValid: Bool{
        guard let password = passwordTextField.text, password.count >= 6  else {
            showError(title: "Password must be valid")
            return false
        }
        return true
    }
}

extension LoginViewController: UserValidation{}
extension RegisterViewController: UserValidation{}
 
