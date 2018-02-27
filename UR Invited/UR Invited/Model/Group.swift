//
//  Group.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation

class Group {
    
    private var _groupTitle: String
    private var _groupId: String
    private var _memberCount: Int
    private var _members: [String]
    private var _isBrandInvited: Bool
    
    var groupTitle: String {
        return _groupTitle
    }
    
    var isBrandInvited: Bool {
        return _isBrandInvited
    }
    
    var groupId: String {
        return _groupId
    }
    
    var memberCount: Int {
        return _memberCount
    }
    
    var members: [String] {
        return _members
    }
    
    init(title: String, id: String, members: [String], memberCount: Int, isBrandInvited: Bool) {
        self._groupTitle = title
        self._groupId = id
        self._members = members
        self._memberCount = memberCount
        self._isBrandInvited = isBrandInvited
    }
    
    
}
