//
//  ChatViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    // MARK: Outlets
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var composeMessageView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: ItalicPlaceholderTextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
   
    
    
    
    // MARK: Variables

    // Setup an initial group optionally
    var group: Group?
    
    // Set local array for messages
    var messageArray = [Message]()
    
   
    // Set notice flag
    var noticeFlag = false
    
   
    
    var menuOpen = false // counter to close and open button
    
    var menuUiView = UIView() // Creates the UIView for the menu
    
    let myOffersButton = UIButton() // Create a button for my offers
    let guestButton = UIButton() //Create a button for my guest in invite
    let muteButton = UIButton() //Create a button for my mute button
    
    
    // MARK: Actions
    
    // Send Button
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        // Send message to database if textfield is not empty
        // Check if message is not empty
        
        if messageTextField.text != "" {
            
            var currentUsername = ""
            
           
            
            // Disable textfield and send button
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            
            DataService.instance.getUsername(forUID: (Auth.auth().currentUser?.uid)!, handler: { (returnedUsername) in
                currentUsername = returnedUsername
                
                DataService.instance.getProfilePictureURL(forUID: (Auth.auth().currentUser?.uid)!, handler: { (returnedURL) in
                    
                    let profileImageURL = returnedURL
                    
                    // Upload message
                    DataService.instance.uploadPost(withMessage: self.messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, andUsername: currentUsername, andProfilePictureURL: profileImageURL,  withGroupKey: self.group?.groupId, sendComplete: { (complete) in
                        
                        if complete {
                            // Clear textfield
                            self.messageTextField.text = ""
                            // Enabled texfield and button
                            self.messageTextField.isEnabled = true
                            self.sendButton.isEnabled = true
                            print("messages count AFTER sending: \(self.messageArray.count)")
                            
                        }
                    })
                    
                    
                })
                
                
               
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
        
        createUiView(views: menuUiView)
        createMyOffersButton()
        myOffersButton.isHidden = true
        createGuestButton()
        guestButton.isHidden = true
        createMuteButton()
        muteButton.isHidden = true
        
        self.chatTableView.estimatedRowHeight = 200
        self.chatTableView.rowHeight = UITableViewAutomaticDimension;
        
        
        // Bind to keyboard
        composeMessageView.bindToKeyboard()

        // Set self as Table view delegate and data source
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        
        // Register Xib files for custom cells
        self.chatTableView.register(UINib(nibName: "SentMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        self.chatTableView.register(UINib(nibName: "ReceivedMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        self.chatTableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeCell")
        
        
        // Set self as Text Field delegate
        messageTextField.delegate = self
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
        
        // Guest option button pressed
        guestButton.addTarget(self, action: #selector(displayCurrentAndNewGuest(_:)), for: .touchUpInside)

    }
   
    
    // Setup the view with data from group
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        // Set title and members label
        groupNameLabel.text = group?.groupTitle
        guard let memberCount = group?.memberCount else {return}
        membersLabel.text = "\(memberCount) members"
        
        
        
        
        // Observe when there is a change in database
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            // Get messages from the database for current group
            DataService.instance.getAllMessages(forGroup: self.group!) { (returnedGroupMessages) in
                self.messageArray = returnedGroupMessages
                
                print("messages count BEFORE reloading: \(self.messageArray.count)")
                self.chatTableView.reloadData()
                print("messages count AFTER reloading: \(self.messageArray.count)")
                
                // Scroll to bottom of table view
                if self.messageArray.count > 0 {
                    if (self.group?.isBrandInvited)! {
                        self.chatTableView.scrollToRow(at: IndexPath(row: self.messageArray.count - 1 , section: 1), at: .none, animated: true)
                    } else {
                        self.chatTableView.scrollToRow(at: IndexPath(row: self.messageArray.count - 1 , section: 0), at: .none, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    
  
    
    // MARK: TableView Delegate Methods
    
    // Table view Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if there is a brand invited
        if numberOfSections(in: chatTableView) > 1 {
            if section == 0 {
                return 1
            }
        }
        // if there is just one section
        return messageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (group?.isBrandInvited)! {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // If brand was invited and there are two sections
        if numberOfSections(in: chatTableView) > 1 {
            // If first message
            if indexPath.section == 0 {
                guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "NoticeCell") as? NoticeTableViewCell else {return UITableViewCell()}
                
                return cell
            }
        }
        
        
        // If message was sent
        if messageArray[indexPath.row].senderId == Auth.auth().currentUser?.uid {
            guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "SentMessageCell") as? SentMessageTableViewCell else {return UITableViewCell()}
            
            // call configure cell method
            cell.configureCell(messageContent: messageArray[indexPath.row].content)
            
            return cell
            
        } else { // If message was received
            
            guard let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell") as? ReceivedMessageTableViewCell else {return UITableViewCell()}
            
            // Get username for label and then configure cell
            let message = messageArray[indexPath.row]

            let profileImage = UIImageView()
            
            profileImage.sd_setImage(with: URL(string: message.profilePictureURL ), completed: { (image, error, cacheType, url) in

                if error != nil {
                    print(error)
                } else {
                    // call configure cell method
                    cell.configureCell(messageContent: message.content, username: message.username, profileImage: image!)
                }
            
            })
            
//            // Create a profile image depending on the username
//            var profileImage = UIImage(named: "profile_icon")
//
//            if messageArray[indexPath.row].username == "Fanatics" {
//                profileImage = UIImage(named: "fanatics-icon")
//            }
//
//            // call configure cell method
//            cell.configureCell(messageContent: message.content, username: message.username, profileImage: profileImage!)
        
            
            return cell
            
        }
    }
    
  
    
    // Beginning PopUp Menu for group chat options
    
    
    @IBAction func ChatPopUpMenuPressed(_ sender: Any) {
        
        if menuUiView.isHidden == true{
            
            myOffersButton.isHidden = false
            guestButton.isHidden = false
            muteButton.isHidden = false
            menuUiView.isHidden = false
        } else {
            
            myOffersButton.isHidden = true
            guestButton.isHidden = true
            muteButton.isHidden = true
            menuUiView.isHidden = true
        }
        
        
    }
    
    
    // End of PopUp Menu for group chat options
    func createUiView (views: UIView){
        
        views.frame = CGRect.init(x: 179, y: 77, width: 280, height: 180)
        views.backgroundColor = UIColor.black     //give color to the view
        self.view.addSubview(views)
        
        // Contraints for the created view
        
        view.translatesAutoresizingMaskIntoConstraints = true
        let horizontalConstraint = NSLayoutConstraint(item: views, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: views, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 66.84)
        let verticalConstraint = NSLayoutConstraint(item: views, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: views, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -220)
        let widthConstraint = NSLayoutConstraint(item: views, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 280)
        let heightConstraint = NSLayoutConstraint(item: views, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 180)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        views.isHidden = true
        
    }
    
    func createMyOffersButton () {
        
        myOffersButton.setTitle("       My offers", for: .normal)
        myOffersButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        myOffersButton.setTitleColor(#colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1), for: .normal)
        myOffersButton.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        myOffersButton.frame = CGRect(x: 179, y: 77, width: 234.8, height: 60)
        self.view.addSubview(myOffersButton)
        
    }
    
    func createGuestButton(){
        
        guestButton.setTitle("       Guest", for: .normal)
        guestButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        guestButton.setTitleColor(#colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1), for: .normal)
        guestButton.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        guestButton.frame = CGRect(x: 179, y: 137, width: 234.8, height: 60)
        self.view.addSubview(guestButton)
        
    }
    
    func createMuteButton(){
        
        muteButton.setTitle("       Mute notifications off", for: .normal)
        muteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        muteButton.setTitleColor(#colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1), for: .normal)
        muteButton.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        muteButton.frame = CGRect(x: 179, y: 197, width: 234.8, height: 60)
        self.view.addSubview(muteButton)
        
    }
   
    
    // display current and new friends in group function
    func displayFriendsInGroupUiViewController(nameOfEvent: String){
        
        
        let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuestsOptionFromChatViewControllerSB") as! GuestsOptionFromChatViewController
        
        self.addChildViewController(popOverVc)
        popOverVc.view.frame = self.view.frame
        popOverVc.nameOfEventLabel.text = nameOfEvent
        self.view.addSubview(popOverVc.view)
        popOverVc.didMove(toParentViewController: self)
        
        popOverVc.initData(forGroup: group!)
    }
    
    // MARK: Selectors
    
    // tableViewTapped Method
    @objc func tableViewTapped() {
        view.endEditing(true)
        menuUiView.isHidden = true
        myOffersButton.isHidden = true
        guestButton.isHidden = true
        muteButton.isHidden = true
    }
    
    @objc func displayCurrentAndNewGuest(_ button: UIButton) {
        
        displayFriendsInGroupUiViewController(nameOfEvent: (group?.groupTitle)!)
    }
    
}







    

