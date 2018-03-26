//
//  AuthService.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

class AuthService {
    
    // Create singleton class
    static let instance =  AuthService()
    
    
    func registerUser(withEmail email: String, andUsername username: String, andPassword password: String, andProfilePicture profilePicture: UIImage, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            // Set image url
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference()
            let profileImagesRef = storageRef.child("profile_images")
            let imageNameRef = profileImagesRef.child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(profilePicture) {
                imageNameRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    } else {
                        let profilePictureURL = metadata?.downloadURL()?.absoluteString
                        
                        // One Signal id
                        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                        let oneSignalUserId = status.subscriptionStatus.userId
                        
                        let userData = ["provider" : user.providerID, "email" : user.email!, "username": username, "profilePicture": profilePictureURL!, "oneSignalUserId": oneSignalUserId!] as [String : Any]
                        DataService.instance.createFirebaseUser(uid: user.uid, userData: userData)
                    }
                }
            }
            userCreationComplete(true, nil)
        }
        
        
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ())  {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            // Update loggedIn value in Database to true
            DataService.instance.updateLoggedInValue(forUid: (Auth.auth().currentUser?.uid)!, loggedIn: true)
            
            loginComplete(true, nil)
            
        }
    }
    
    
    
}
