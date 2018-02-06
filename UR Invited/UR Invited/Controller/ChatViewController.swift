//
//  ChatViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    

    // MARK: Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var composeViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    var keyboardHeight: CGFloat = 0
    
    
    
    
    

    
    
    // MARK: Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: Change placeholder text
//        var placeHolder = NSMutableAttributedString()
//
//        let attributes = [NSAttributedStringKey.font:UIFont(name: "OpenSans-Italic", size: 12.0)! ]
//
//        // Set the Font
//        placeHolder = NSMutableAttributedString(string:"Type a message", attributes: attributes)
//
//        //     Add attribute
//
//
//        messageTextField.attributedPlaceholder = placeHolder

        // Set self as Table view delegate and data source
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // Set self as Text Field delegate
        messageTextField.delegate = self
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
        
        

        // Notifications for keyboard interaction
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


    }
    
    // MARK: Delegate Methods
    
    // Table view Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        return cell
    }
    
    // tableViewTapped Method
    @objc func tableViewTapped() {
        view.endEditing(true)
    }

    // Textfield Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25) {
            self.composeViewHeightConstraint.constant = self.keyboardHeight + 44
            self.view.layoutIfNeeded()
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {

            self.composeViewHeightConstraint.constant = 44
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
             if self.keyboardHeight >= keyboardSize.height {
               
                    self.composeViewHeightConstraint.constant = self.keyboardHeight + 44
                    self.view.layoutIfNeeded()
                    // TODO: Scroll to table to bottom
                
            } else {
                self.keyboardHeight = keyboardSize.height
                
                    self.composeViewHeightConstraint.constant = self.keyboardHeight + 44
                    self.view.layoutIfNeeded()
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.composeViewHeightConstraint.constant =  44
            self.view.layoutIfNeeded()
        }
        
            
        
    }
    
}

    

