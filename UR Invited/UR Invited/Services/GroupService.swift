//
//  GroupService.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 19/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//


import Foundation
import AWSCore
import AWSDynamoDB
import AWSAuthUI


class GroupService {
    
    // Service instance
    static let instance = GroupService()
    
    
    // Create a message in database function
    func createGroup(named name: String, withCategory category: String, isBrandInvited: Bool) {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let groupItem: Groups = Groups()
        
        // Create id for group
        let uuid = UUID().uuidString
        
        // Set group attributes
        groupItem._userId = AWSIdentityManager.default().identityId as String!
        groupItem._groupId = uuid
        groupItem._creationDate = NSDate().timeIntervalSince1970 as NSNumber
        groupItem._name = name
        groupItem._isBrandInvited = isBrandInvited as NSNumber
        
        // Add members
        groupItem._members?.insert( AWSIdentityManager.default().identityId as String! )
        
    
        //Save a new item
        dynamoDbObjectMapper.save(groupItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
    }
    
    // Read Groups
    func readGroups() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let groupItem: Groups = Groups()
        
        
        // Set message attributes
        groupItem._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(
            Groups.self,
            hashKey: groupItem._userId!,
            rangeKey: groupItem._groupId!,
            completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("An item was read.")
        })
    }
    
    // Insert members
    func insertIntoGroup(member: String, withId groupId: String) {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        
        // Create data object using data models you downloaded from Mobile Hub
        let groupItem: Groups = Groups()
        
        groupItem._userId = AWSIdentityManager.default().identityId
        groupItem._groupId = groupId
        
        // Insert member
        groupItem._members?.insert(member)
        
        
        dynamoDbObjectMapper.save(groupItem, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("New member added to group.")
        })
    }
    
    
}
