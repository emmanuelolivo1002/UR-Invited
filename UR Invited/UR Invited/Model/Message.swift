//
//  Message.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

class Message {
  
    // Declare private variables for encapsulation
    private var _content : String
    private var _senderId: String
    private var _username: String
    private var _profilePictureURL: String
    
    // initializer
    init(content: String, senderId: String, username: String, profilePictureURL: String) {
        self._content = content
        self._senderId = senderId
        self._username = username
        self._profilePictureURL = profilePictureURL
    }
    
    // get data from private variables
    var content : String {
        return _content
    }
    
    var senderId : String {
        return _senderId
    }
    
    var username: String {
        return _username
    }
    
    var profilePictureURL: String {
        return _profilePictureURL
    }
    
    
}
