//
//  MessageService.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 16/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB
import AWSAuthUI


class MessageService {
    
    // Service instance
    static let instance = MessageService()
    
    
    // Create a message in database function
    func createMessage( groupId: String, content: String, username: String) {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let messageItem: Messages = Messages()
        
        // Set message attributes
        messageItem._userId = AWSIdentityManager.default().identityId as String!
        messageItem._groupId = groupId as String!
        messageItem._content = content as String!
        messageItem._creationDate = NSDate().timeIntervalSince1970 as NSNumber
        messageItem._username = username as String!
        
        messageItem._profilePicture = "test" as String!
        
        print("Message to save in DB: \ncontent \(String(describing: messageItem._content)) \nuserId: \(String(describing: messageItem._userId)) \ngroupID: \(String(describing: messageItem._groupId)) \nCreation Date: \(String(describing: messageItem._creationDate)) \nusername: \(String(describing: messageItem._username)) \nprofile picture: \(String(describing: messageItem._profilePicture))")
        
        // TODO: Implement profile picture
        //var _profilePicture: String?
       
        
        //Save a new item
        dynamoDbObjectMapper.save(messageItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
    }
    
    // Read Messages
    func readMessages() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let messageItem: Messages = Messages()
        
        
        // Set message attributes
        messageItem._userId = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(
            Messages.self,
            hashKey: messageItem._userId!,
            rangeKey: messageItem._groupId!,
            completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("An item was read.")
        })
    }
    
    // Query messages
    func queryMessage(forGroup group: Groups) {
        
        // 1) Configure the query
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#groupId >= :groupId AND #userId = :userId"
        
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#groupId": "groupId"
        ]
        queryExpression.expressionAttributeValues = [
            ":groupId": group._groupId!,
            ":userId": AWSIdentityManager.default().identityId!
        ]
        
        // 2) Make the query
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.query(Messages.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                for messages in output!.items {
                    let messageItem = messages as? Messages
                    print("\(messageItem!._content!)")
                }
            }
        }
    }
    

}

