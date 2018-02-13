//
//  TestVariables.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 12/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation



class TestVariables  {
    
    static let instance = TestVariables()
    
    var testGroupArray = [Groups]()
    var newGroupOne: Groups = Groups()
    var newGroupTwo: Groups = Groups()
    var members: Set<String> = []
    
    func loadGroupArray() -> [Groups] {
        
        newGroupOne._name = "America vs Tiburones"
        newGroupOne._groupId = "group1id"
        newGroupOne._category = "Sports"
        newGroupOne._members = ["Emm", "Tony"]
        
        newGroupTwo._name = "Kurt Dancing Extravaganza"
        newGroupTwo._groupId = "group2id"
        newGroupTwo._category = "Music"
        newGroupTwo._members = ["Josh","Kurt","Alex"]
        
        testGroupArray.append(newGroupOne)
        testGroupArray.append(newGroupTwo)
        
        return testGroupArray
    }
}



