//
//  GroupTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 12/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class GroupTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    @IBOutlet weak var numberOfUnreadMessagesLabel: UILabel!
    @IBOutlet weak var unreadMessagesNotificationView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var membersStackView: UIStackView!
    
    // Constraint Outlets
    @IBOutlet weak var membersStackViewWidthConstraint: NSLayoutConstraint!
    
    
   
    // Flag
    var countFlag = 0
    let maxMembersToDisplay = 10
    
    // Array of URL
    var picturesURL = [String]()
    
    
   
    // MARK: Functions
//
//    func loadAllPictures(members: [String], handler: @escaping(_ imageViewArray: [UIImageView]) -> ()) {
//
//        var imageViewArray = [UIImageView]()
//
//        // loop through all members of a group to set the profile image
//        for user in members {
//
//            DataService.instance.getProfilePictureURL(forUID: user, handler: { (returnedURL) in
//
//                let imageView = RoundImage()
//
//                imageView.sd_setImage(with: URL(string: returnedURL), completed: { (image, error, cache, url) in
//
//                    //            imageView.image = UIImage(named: "group_work_icon")
//                    imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
//                    imageView.setupView()
//
//                    // Set constraints
//                    imageView.heightAnchor.constraint(equalToConstant: 32)
//                    imageView.widthAnchor.constraint(equalToConstant: 32)
//
//
//                    // set image shadow
//                    imageView.layer.shadowColor = UIColor.black.cgColor
//                    imageView.layer.shadowOpacity = 1
//                    imageView.layer.shadowOffset = CGSize.zero
//                    imageView.layer.shadowRadius = 1
//
//                    // add profile image to Array
//                    imageViewArray.append(imageView)
//                })
//            })
//        }
//
//        print("imageViewArray.count: \(imageViewArray.count)")
//        handler(imageViewArray)
//    }
    
    
    // Configure elements in cell wit a Group object
    func configureCell(group: Group) {
        
        
        groupNameLabel.text = group.groupTitle
        
        numberOfMembersLabel.text =  "\(group.memberCount) members"
        
        
        membersStackViewWidthConstraint.constant = CGFloat(group.memberCount * 32 + (group.memberCount * 3))
        
        // loop through all members of a group to set the profile image
        for user in group.members {
            
            if countFlag < group.memberCount {
                
                DataService.instance.getProfilePictureURL(forUID: user, handler: { (returnedURL) in
                    
                    let imageView = RoundImage()
                    
                    imageView.sd_setImage(with: URL(string: returnedURL), completed: { (image, error, cacheType, url) in
                        
                        if error != nil {
                            print(error)
                        } else {
                            
                            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                            imageView.setupView()
        
                            // Set constraints
                            imageView.heightAnchor.constraint(equalToConstant: 32)
                            imageView.widthAnchor.constraint(equalToConstant: 32)
                            
                            // set image shadow
                            imageView.layer.shadowColor = UIColor.black.cgColor
                            imageView.layer.shadowOpacity = 1
                            imageView.layer.shadowOffset = CGSize.zero
                            imageView.layer.shadowRadius = 1
                            
                            
                            // add profile image to stackview
                            self.membersStackView.addArrangedSubview(imageView)
                            
                            
                            self.countFlag += 1
                            
                            print("countFlag \(self.countFlag)")
                        }
                    })
                })
            }
        }
    }
}


