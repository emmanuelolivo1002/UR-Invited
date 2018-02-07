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
    
    
    // TODO: Delete these two
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    var keyboardHeight: CGFloat = 0
    
    
    // Test Variables
    var messageArray = [Message]()
    
    var newMessage = Message(content: "Hello", username: "Josh", isSender: true)
    
    
    // TODO: Check if a brand was invited
     var noticeFlag = false
    
    

    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test message Array
        messageArray.append(newMessage)
        newMessage = Message(content: "Hi", username: "Josh", isSender: true)
        messageArray.append(newMessage)
        
        
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
        
        
        // Register Xib files for custom cells
        self.chatTableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeCell")
        
        self.chatTableView.register(UINib(nibName: "SentMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        
        self.chatTableView.register(UINib(nibName: "ReceivedMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        
        
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
        
        // If a brand was invited to a chat increase the number of rows
        if noticeFlag {
            return messageArray.count + 1
        } else {
            return messageArray.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if there is a brand invited
        if noticeFlag {
            if indexPath.row == 0 { // if first message
                if let noticeCell = chatTableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeTableViewCell {
                    
                    return noticeCell
                }
            } else { // if new message
                
                // If new message was sent
                if messageArray[indexPath.row - 1].isSender {
                    
                    if let cell = chatTableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as? SentMessageTableViewCell {
                        
                        
                        cell.messageText?.text = messageArray[indexPath.row - 1].content
                        
                        
                        return cell
                    }
                } else { // if new message was received
                    if let cell = chatTableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as? SentMessageTableViewCell {
                        
                        // TODO: set ReceivedMessageTableViewCell
                        
                        cell.messageText?.text = messageArray[indexPath.row - 1].content
                        
                        return cell
                    }
                    
                }
                
            }
           
        } else { // if no brand was invited
            
            // If new message was sent
            if messageArray[indexPath.row].isSender {
                
                if let cell = chatTableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as? SentMessageTableViewCell {
                    
                    
                    cell.messageText?.text = messageArray[indexPath.row].content
                    
                    
                    return cell
                }
            } else { // if new message was received
                if let cell = chatTableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as? SentMessageTableViewCell {
                    // TODO: Change to ReceivedMessageTableViewCell
                    
                    cell.messageText?.text = messageArray[indexPath.row].content
                    
                    return cell
                }
                
            }
        
            
            
        }
        
        return UITableViewCell()
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

    

