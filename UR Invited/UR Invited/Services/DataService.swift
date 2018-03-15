//
//  DataService.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation
import Firebase

// Base URL for Firebase Database
let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
 
    
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS : DatabaseReference {
        return _REF_GROUPS
    }
    
    
    
    // MARK: Functions
    
    // Function to create new users in Database
    func createFirebaseUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    // Function to get username for a specific uid
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        
        // Get a snapshot from the Users table
        REF_USERS.observeSingleEvent(of: .value) { (usernameSnapshot) in
            
            // create a Snapshot otherwise return
            guard let usernameSnapshot = usernameSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // loop through snapshot
            for user in usernameSnapshot {
                // user is equal to the uid return its email
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "username").value as! String)
                }
            }
        }
    }
    
    func getUserData(forUID uid: String, handler: @escaping (_ user: User) -> ()) {
        // Get a snapshot from the Users table
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            // create a Snapshot otherwise return
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // loop through snapshot
            for user in userSnapshot {
                // user is equal to the uid return its edata
                if user.key == uid {
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let profilePicture = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let userFound = User(uid: user.key, username: username, profilePicture: profilePicture)
                    handler(userFound)
                }
            }
        }
    }
    
    // Function to upload message to Group 
    func uploadPost(withMessage message: String, forUID uid: String, andUsername username: String, andProfilePictureURL profilePictureURL: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        if groupKey != nil {
            // if group key exists send to group
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid, "username": username, "profilePictureURL": profilePictureURL])
            
            sendComplete(true)
            
        }
    }
    
    // Function to get all messages for specific group
    func getAllMessages(forGroup group: Group, handler: @escaping(_ messages: [Message]) -> ()) {
        // Instantiate a message array to store messages for the group
        var groupMessageArray = [Message]()
        
        // Observe all messages in group passed
        REF_GROUPS.child(group.groupId).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            //Loop through snapshot
            for groupMessage in groupMessageSnapshot {
                // Get all elements of message and store them in a message object
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let username = groupMessage.childSnapshot(forPath: "username").value as! String
                let profilePictureURL = groupMessage.childSnapshot(forPath: "profilePictureURL").value as! String
                
                let message = Message(content: content, senderId: senderId, username: username, profilePictureURL: profilePictureURL)
                
                // Append message to array
                groupMessageArray.append(message)
            }
            // Pass array back
            handler(groupMessageArray)
        }
        
    }
    

    // Function for searching usernames
    func getUsers(forSearchQuery query: String, handler: @escaping (_ usersArray: [User]) -> ()) {
        // Initialize array of usernames that will be shown
        var usersArray = [User]()
        
        // Get snapshot of all users
        REF_USERS.observe(.value) { (userSnapshot) in
            
            // Create userSnapshot otherwise return
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // Loop through users in snapshot
            for user in userSnapshot {
                // Get username and Profile picture
                let username = user.childSnapshot(forPath: "username").value as! String
                let profilePicture = user.childSnapshot(forPath: "profilePicture").value as! String
                
                // If username contains whats in the query and is not the current user's username
                if username.lowercased().contains(query.lowercased()) == true && username != Auth.auth().currentUser?.email {
                    
                    // Append to array of users shown
                    let userFound = User(uid: user.key, username: username, profilePicture: profilePicture)
                    
                    usersArray.append(userFound)
                }
                handler(usersArray)
            }
        }
    }
    
    // Function for searching emails
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        // Initialize array of emails that will be shown
        var emailArray = [String]()
        
        // Get snapshot of all users
        REF_USERS.observe(.value) { (userSnapshot) in
            
            // Create userSnapshot otherwise return
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // Loop through users in snapshot
            for user in userSnapshot {
                // Get email
                let email = user.childSnapshot(forPath: "email").value as! String
                
                // If email contains whats in the query and is not the current user's email
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    // Append to array of emails shown
                    emailArray.append(email)
                }
                handler(emailArray)
            }
        }
    }
    
    // Function to get ids for usernames
    func getIds(forUsernames usernames: [String], handler: @escaping(_ uidArray: [String]) -> ()) {
        // Create a snapshot for all usernames
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            // Initialize an array for ids
            var idArray = [String]()
            
            // Loop through user snapshot
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                // Get username of user
                let username = user.childSnapshot(forPath: "username").value as! String
                
                // if email is in array of usernames requested
                if usernames.contains(username) {
                    // append Id to idArray to return
                    idArray.append(user.key)
                }
            }
            
            // Return array in handler
            handler(idArray)
        }
    }
    
    
    
    
    // Function to get all the usernames in a group
    func getUsernames(forGroup group: Group, handler: @escaping(_ emailArray: [String]) -> ()) {
        //Initialize array to be passed back
        var emailArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usernamesSnapshot) in
            // Loop through user snapshot
            guard let usernamesSnapshot = usernamesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usernamesSnapshot {
                // if userId of current iteration is in group
                if group.members.contains(user.key) {
                    // Set an email and append to variable
                    let email = user.childSnapshot(forPath: "email").value as! String
                    
                    emailArray.append(email)
                }
            }
            // pass back email array
            handler(emailArray)
        }
    }
    
    // Function to create group in database
    func createGroup(withTitle title: String, forUsers users: [User], handler: @escaping(_ createdGroup: Bool) -> ()) {
        
        // Array of ids
        var ids = [String]()
        
        // Loop through array of users to get ids
        for user in users {
            ids.append(user.uid)
        }
        
        // Set flag for brand Invited
        var isBrandInvited = false
        
        if ids.contains("0") {
            isBrandInvited = true
        } else {
            isBrandInvited = false
        }
        
        // Add group to Database
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "members": ids, "isBrandInvited": isBrandInvited ])
       
        DataService.instance.createBrandMessage { (complete) in
            print("Group with brand message created")
        }
        
        handler(true)
    }
    
    // Function to get all users in a group
    func getAllUsersInGroup (group: Group, handler: @escaping(_ usersArray: [User]) -> ()) {
        
        // Initialize array to be passed back
        var usersArray = [User]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all users
            for user in usersSnapshot {
                
                // if userId of current iteration is NOT in group
                if group.members.contains(user.key) {
                    
                    // Append user to array
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let profilePicture = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let userFound = User(uid: user.key, username: username, profilePicture: profilePicture)
                    
                    usersArray.append(userFound)
                }
            }
            
            handler(usersArray)
            
        }
        
    }
    
    // Function to get all users NOT in a group
    func getAllUsersNotInGroup (group: Group, handler: @escaping(_ usersArray: [User]) -> ()) {
    
        // Initialize array to be passed back
        var usersArray = [User]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all users
            for user in usersSnapshot {
                
                // if userId of current iteration is NOT in group
                if !group.members.contains(user.key) {
                    
                    // Append user to array 
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let profilePicture = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let userFound = User(uid: user.key, username: username, profilePicture: profilePicture)
                    
                    usersArray.append(userFound)
                }
            }
            
            handler(usersArray)
        
        }
        
    }
    
    
    // Function to invite users
    func inviteUsers(toGroup group: Group, usersInvited: [User], invitationComplete: @escaping (_ status: Bool) -> ()) {
        
        
        // Initialize array to be passed back
        var usersArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all users
            for user in usersSnapshot {
                // if userId of current iteration is in group
                if group.members.contains(user.key) {
                    usersArray.append(user.key)
                }
            }
            
            for user in usersInvited {
                usersArray.append(user.uid)
            }
            
            
            // Add group to Database
            self.REF_GROUPS.child(group.groupId).updateChildValues(["members": usersArray])
            
            invitationComplete(true)
        }
    }
    
    
    // Function to create brand message
    func createBrandMessage(handler: @escaping(_ createdBrandMessage: Bool) -> ()) {
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            
            // create snapshot
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all groups
            for group in groupSnapshot {
                let isBrandInvited = group.childSnapshot(forPath: "isBrandInvited").value as! Bool
                
                if isBrandInvited {
                    
                    // Create an instance of current group
                    let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                    let groupTitle = group.childSnapshot(forPath: "title").value as! String
                    let currentGroup = Group(title: groupTitle, id: group.key, members: memberArray, memberCount: memberArray.count, isBrandInvited: isBrandInvited)
                    
                    
                    DataService.instance.getAllMessages(forGroup: currentGroup, handler: { (returnedMessageArray) in
                        // Set up a flag
                        var doesBrandMessageExist = false
                        
                        // Loop through all messages
                        for message in returnedMessageArray {
                            // If there is a message from id 0 then brand message already exists
                            if message.senderId == "0" {
                                doesBrandMessageExist = true
                            }
                        }
                        
                        // If brand message doesn't exist then create
                        if doesBrandMessageExist == false {
                            DataService.instance.uploadPost(withMessage: "This is a test message from Fanatics", forUID: "0", andUsername: "Fanatics", andProfilePictureURL: "https://firebasestorage.googleapis.com/v0/b/ur-invited.appspot.com/o/profile_images%2Ffanatics-icon%403x.png?alt=media&token=2fd769bc-1ece-4177-b432-feff90590ec0", withGroupKey: group.key, sendComplete: { (complete) in
                                if complete {
                                    print("Fanatics message created")
                                }
                            })
                        }
                    })
                }
            }
        }
        
        
        handler(true)
    }
    
    func getAllUsers(handler: @escaping(_ usersArray: [User]) -> ()) {
        
        // Initialize array to be passed back
        var usersArray = [User]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all users
            for user in usersSnapshot {
                if user.key != Auth.auth().currentUser?.uid {
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let profilePicture = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let userFound = User(uid: user.key, username: username, profilePicture: profilePicture)
                    usersArray.append(userFound)
                }
            }
            
            handler(usersArray)
            
        }
        
    }
    
    
    // Function to get all users in database
    func getAllUsernames(handler: @escaping(_ usernamesArray: [String]) -> ()) {
        
        // Initialize array to be passed back
        var usernameArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usernamesSnapshot) in
            
            guard let usernamesSnapshot = usernamesSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            // Loop through all users
            for user in usernamesSnapshot {
                if user.key != Auth.auth().currentUser?.uid {
                    let username = user.childSnapshot(forPath: "username").value as! String
                    usernameArray.append(username)
                }
            }
            
            handler(usernameArray)
            
        }
        
    }
    
    // Function to get all groups
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        
        // Initialize group array to be returned
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // Loop through snapshot
            for group in groupSnapshot {
                
                // Create an array to store every member of group
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                // If group contains current user create a group to be appended to array
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    
                    // get elements from the group in the database
                    let title = group.childSnapshot(forPath: "title").value as? String
                    
                    let isBrandInvited = group.childSnapshot(forPath: "isBrandInvited").value as? Bool
                    
                    
                    let group = Group(title: title!, id: group.key, members: memberArray, memberCount: memberArray.count, isBrandInvited: isBrandInvited!)
                    
                    // Append group to group array
                    groupsArray.append(group)
                }
            }
            
            // Pass back groups array
            handler(groupsArray)
        }
    }
    
    
    func getAllProfilePictures(forGroup group: Group, handler: @escaping(_ imageViewArray: [UIImageView]) -> () ) {
        
        //Initialize array to be passed back
        var imageArray = [UIImageView]()
        
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
            // Loop through user snapshot
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersSnapshot {
                
                // if userId of current iteration is in group
                if group.members.contains(user.key) {
                    
                    // Set an imageURL and append to array
                    let url = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    let imageView = RoundImage()
                    
                    imageView.sd_setImage(with: URL(string: url ), completed: { (image, error, cacheType, url) in
                        
                        imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                        imageView.setupView()
                        
                        // Set constraints
                        imageView.heightAnchor.constraint(equalToConstant: 32)
                        imageView.widthAnchor.constraint(equalToConstant: 32)
                        
                        
                        // set image shadow
                        imageView.layer.shadowColor = UIColor.black.cgColor
                        imageView.layer.shadowOpacity = 1
                        imageView.layer.shadowOffset = CGSize.zero
                        imageView.layer.shadowRadius = 1
                        
                        imageArray.append(imageView)
                    })
                }
            }
            // pass back image array
            handler(imageArray)
        }
        
    }
    
    // Get URL for any user profile picture
    func getProfilePictureURL(forUID uid: String, handler: @escaping(_ reference: String) -> ()) {
        
        // Get a snapshot from the Users table
        REF_USERS.observeSingleEvent(of: .value) { (usernameSnapshot) in
            
            // create a Snapshot otherwise return
            guard let usernameSnapshot = usernameSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // loop through snapshot
            for user in usernameSnapshot {
                // user is equal to the uid return its email
                if user.key == uid {
                    
                    let profilePictureURL = user.childSnapshot(forPath: "profilePicture").value as! String
                    
                    handler(profilePictureURL)
                }
            }
        }
        
    }
    
    
    
}

