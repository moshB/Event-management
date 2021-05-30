//
//  LoginViewController.swift
//  event management
//
//  Created by Mosh on 16/02/2021.
//

import UIKit
import FirebaseAuth
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailTextField.text, isEmailValid,
              let password = passwordTextField.text, isPasswordValid
              else {
              return
        }
        //start the auth proccess:
        sender.isEnabled = false //can't click Register 2 times in a row
        showProgress(title: "Please Wait")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](result, err) in
            if let err = err {
                self?.showError(title: err.localizedDescription)
                sender.isEnabled = true
                return
            }
            self?.showSuccess(title: "Done!")
            Router.shared.determineRootViewController()
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
