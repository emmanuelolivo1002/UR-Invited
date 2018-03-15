//
//  RegisterViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 7/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class RegisterViewController:  UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        
        // Present the UIImagePickerController
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if emailTextfield.text != nil && passwordTextField.text != nil && self.usernameTextField.text != nil {
            AuthService.instance.registerUser(withEmail: self.emailTextfield.text!, andUsername: self.usernameTextField.text!, andPassword: self.passwordTextField.text!, andProfilePicture: self.profileImage.image!, userCreationComplete: { (success, error) in
                
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
        }
    }
    
    
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // Image Picker functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Selectors
    
    // tableViewTapped Method
    @objc func viewTapped() {
        view.endEditing(true)
    }

}
