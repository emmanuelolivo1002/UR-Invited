//
//  ProfileViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class ProfileViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataService.instance.getProfilePictureURL(forUID: (Auth.auth().currentUser?.uid)!) { (returnedURL) in
            self.profileImageView.sd_setImage(with: URL(string: returnedURL), completed: nil)
            
        }
        
        userLabel.text = Auth.auth().currentUser?.email
    }

    // MARK: Actions
    @IBAction func signOutButtonPressed(_ sender: Any) {
        // Create logout popup
        let logoutPopup = UIAlertController(title: "Log out", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        // Create action to happend when popup button is tapped
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive) { (buttonTapped) in
            
            // Perform sign out in a do try block
            do {
                // Try to perform sign out
                try Auth.auth().signOut()
                // if successful present auth View Controller
                let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
                self.present(authViewController!, animated: true, completion: nil)
                
            } catch {
                // If there is an error
                print(error)
            }
        }
        
        //Add action created to popup
        logoutPopup.addAction(logoutAction)
        // Present logout popup
        present(logoutPopup, animated: true, completion: nil)
        
    }
    
}
