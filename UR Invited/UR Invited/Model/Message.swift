//
//  Message.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

class Message {
    let content : String
    let username: String
    let isSender: Bool
    
    init (content: String, username: String, isSender: Bool) {
        self.content = content
        self.username = username
        self.isSender = isSender
    }
    
    
}
