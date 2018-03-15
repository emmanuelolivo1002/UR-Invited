//
//  TabBarViewController.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI


class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // TODO: Set profile picture in tab bar item for Profile

//        DataService.instance.getProfilePictureURL(forUID: (Auth.auth().currentUser?.uid)!) { (returnedURL) in
////            let profileImageView = RoundImage()
//            let profileImageView = UIImageView()
//
//            profileImageView.sd_setImage(with: URL(string: returnedURL), completed: { (returnedImage, error, nil, url) in
//                if error != nil {
//                    print(error)
//                } else {
//                    self.tabBar.items?[4].image = returnedImage?.withRenderingMode(.alwaysOriginal)
//                    self.tabBar.items?[4].selectedImage = returnedImage?.withRenderingMode(.alwaysOriginal)
//                }
//
//            })
//
//
//        }
        

        // Set default tab to be Events tab
        self.selectedIndex = 2
    }

    

}
