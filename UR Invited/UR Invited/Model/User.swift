//
//  User.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 9/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

class User {
    private var _uid: String
    private var _username: String
    private var _profilePicture: String
    
    var uid: String {
        return _uid
    }
    
 
    var username: String {
        return _username
    }
    
    var profilePicture: String {
        return _profilePicture
    }
    
  
    init(uid: String, username: String, profilePicture: String) {
        self._uid = uid
        self._username = username
        self._profilePicture = profilePicture
    }
    
}
