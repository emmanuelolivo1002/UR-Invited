//
//  LoginViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.delegate = self
        passwordTextField.delegate = self
    }

  
    @IBAction func signInButtonPressed(_ sender: Any) {
        if emailTextfield.text != nil && passwordTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextfield.text!, andPassword: passwordTextField.text!, loginComplete: { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: error?.localizedDescription))
                }
                
                // if login was not successful, try to register user
                AuthService.instance.registerUser(withEmail: self.emailTextfield.text!, andPassword: self.passwordTextField.text!, userCreationComplete: { (success, error) in
                    
                    if success {
                        // Log in user
                        AuthService.instance.loginUser(withEmail: self.emailTextfield.text!, andPassword: self.passwordTextField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user")
                        })
                    } else {
                        print(String(describing: error?.localizedDescription))
                        
                    }
                })
                
            })
            
        }
    }
    

}
