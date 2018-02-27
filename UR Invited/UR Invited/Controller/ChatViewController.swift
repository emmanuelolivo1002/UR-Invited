//
//  ChatViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    

    // MARK: Outlets
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var composeMessageView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
   
    
    
    // MARK: Variables

    // Setup an initial group optionally
    var group: Group?
    
    // Set local array for messages
    var messageArray = [Message]()
   
    // Set notice flag
    var noticeFlag = false
    
   
    
    // MARK: Actions
    
    // Send Button
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        // Send message to database if textfield is not empty
        // Check if message is not empty
        
        if messageTextField.text != "" {
            
            // Disable textfield and send button
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            
            // Upload message
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.groupId, sendComplete: { (complete) in
                
                if complete {
                    // Clear textfield
                    self.messageTextField.text = ""
                    // Enabled texfield and button
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.chatTableView.reloadData()
                }
            })
        }
    }
    
    // Back Button
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Go Back")
        }
        
    }
    
    // MARK: Functions
    
    // Function to initialize current group with group passed from GroupsViewController
    func initData(forGroup group: Group) {
        self.group = group
        self.noticeFlag = group.isBrandInvited
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind to keyboard
        composeMessageView.bindToKeyboard()
        
        
        // TODO: Change textfield placeholder text and maybe change to a TextView
        
        

        // Set self as Table view delegate and data source
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        
        // Register Xib files for custom cells
        self.chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
        
        // Set self as Text Field delegate
        messageTextField.delegate = self
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)

    }
    
    // Setup the view with data from group
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chatTableView.estimatedRowHeight = 0
        self.chatTableView.estimatedSectionHeaderHeight = 0
        self.chatTableView.estimatedSectionFooterHeight = 0
        
        // Set title and members label
        groupNameLabel.text = group?.groupTitle
        guard let memberCount = group?.memberCount else {return}
        membersLabel.text = "\(memberCount) members"
        
        
        // Observe when there is a change in database
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            // Get messages from the database for current group
            DataService.instance.getAllMessages(forGroup: self.group!) { (returnedGroupMessages) in
                self.messageArray = returnedGroupMessages
                self.chatTableView.reloadData()
                
                // Scroll to bottom of table view
                if self.messageArray.count > 0 {
                    self.chatTableView.scrollToRow(at: IndexPath(row: self.messageArray.count - 1 , section: 0), at: .none, animated: true)
                }
            }
        }
        
        
    }
    
    // Configure view elements
    func configureView() {
        DataService.instance.getAllMessages(forGroup: group!) { (returnedMessageArray) in
            self.messageArray = returnedMessageArray
        }
        
        groupNameLabel.text = group?.groupTitle
        
        guard let memberCount = group?.memberCount else {return}
        membersLabel.text = "\(memberCount) members"
        
    }
    
    // MARK: TableView Delegate Methods
    
    // Table view Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO: Implement if brand is invited
        
//        // If a brand was invited to a chat increase the number of rows
//        if noticeFlag {
//            return messageArray.count + 1
//        } else {
//            return messageArray.count
//        }
        return messageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: Implement if Brand is invited with notice flag
        
//        // if there is a brand invited
//        if noticeFlag {
//            if indexPath.row == 0 { // if first message
//                if let noticeCell = chatTableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeTableViewCell {
//
//                    return noticeCell
//                }
//            } else { // if new message
//
//                if let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell {
//
//                    // call configure cell method
//                    cell.configureCell(messageContent: messageArray[indexPath.row].content , isSender: true, username: messageArray[indexPath.row].senderId, profilePicture: "profile_icon")
//
//                    return cell
//                }
//            }
//
//        } else { // if no brand was invited
        
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageTableViewCell else {return UITableViewCell()}
      
        // call configure cell method
        cell.configureCell(messageContent: messageArray[indexPath.row].content , isSender: false, username: messageArray[indexPath.row].senderId, profilePicture: "profile_icon")
        
        return cell
    }
    
    
    
    // tableViewTapped Method
    @objc func tableViewTapped() {
        view.endEditing(true)
    }
    
   

    
    
    
    

    
    
}

    

