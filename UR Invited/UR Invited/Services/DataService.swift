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
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    // Function to upload post to Group or Regular Feed
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        if groupKey != nil {
            // if group key exists send to group
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
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
                let message = Message(content: content, senderId: senderId)
                
                // Append message to array
                groupMessageArray.append(message)
            }
            // Pass array back
            handler(groupMessageArray)
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
                // Get email of user
                let email = user.childSnapshot(forPath: "email").value as! String
                
                // if email is in array of usernames requested
                if usernames.contains(email) {
                    // append Id to idArray to return
                    idArray.append(user.key)
                }
            }
            
            // Return array in handler
            handler(idArray)
        }
    }
    
    // Funtion to get all the usernames in a group
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
    func createGroup(withTitle title: String, forUserIds ids: [String], handler: @escaping(_ createdGroup: Bool) -> ()) {
        // Add group to Database
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "members": ids])
        handler(true)
    }
    
    // Function to get all groups
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        
        // Initialize group array to be returned
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // Loop through snapshot
            for group in groupSnapshot {
                
                print("Looping through database")
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
    
}

