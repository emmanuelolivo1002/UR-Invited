//
//  GroupTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 12/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    @IBOutlet weak var numberOfUnreadMessagesLabel: UILabel!
    @IBOutlet weak var unreadMessagesNotificationView: UIView!
    @IBOutlet weak var membersStackView: UIStackView!
    
    
    // Flag
    var countFlag = 0
    
    
    

    
    // Configure elements in cell wit a Group object
    func configureCell(group: Group) {
        
        groupNameLabel.text = group.groupTitle
        
        numberOfMembersLabel.text =  "\(group.memberCount) members"
       
      
        
        // loop through all members of a group to set the profile image
        for _ in group.members {
            let profileImage = UIImage(named: "group_member_profile")
            let imageView = UIImageView(image: profileImage)
            
            // set image shadow
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 1
            imageView.layer.shadowOffset = CGSize.zero
            imageView.layer.shadowRadius = 1
            
            countFlag += 1
            
            if countFlag <= group.members.count {
                // add profile image to stackview
                membersStackView.addArrangedSubview(imageView)
            }
        }
    }
    
}
