//
//  LoginViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class AuthViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: Actions
    
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if emailTextfield.text != nil && passwordTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextfield.text!, andPassword: passwordTextField.text!, loginComplete: { (success, error) in
                if success {
                    
                    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                    let userID = status.subscriptionStatus.userId
                    
                    OneSignal.sendTag("loggedIn", value: "true")
                    
                    // Update OneSignal userId
                    DataService.instance.updateOneSignalId(forUid: (Auth.auth().currentUser?.uid)!, withNewOneSignalId: userID!, updateComplete: { (completed) in
                        
                        if completed {
                            self.dismiss(animated: true, completion: nil)

                        }
                        
                    })
                    
                } else {
                    print(String(describing: error?.localizedDescription))
                }
            })
        }
    }
    
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        passwordTextField.delegate = self
        
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Selectors
    
    // tableViewTapped Method
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
}

