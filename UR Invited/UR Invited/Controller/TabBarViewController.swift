//
//  TabBarViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show Sign-in screen if user is not logged in
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: (self.navigationController)!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign in successful.
                                        }
                })
        }
        
        // Set default tab to be Events tab
        self.selectedIndex = 2
    }

    

}
