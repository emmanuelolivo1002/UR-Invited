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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure elements in cell wit a Group object
    func configureCell(group: Groups) {
        groupNameLabel.text = group._name
        categoryLabel.text = group._category
        
        if let numberOfMembers = group._members?.count {
            numberOfMembersLabel.text =  "\(String(describing: numberOfMembers)) members"
        } else {
            numberOfMembersLabel.text = "No members"
        }
        
        // loop through all members of a group to set the profile image
        for _ in group._members! {
            let profileImage = UIImage(named: "group_member_profile")
            let imageView = UIImageView(image: profileImage)
            
            // set image shadow
            imageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 1
            imageView.layer.shadowOffset = CGSize.zero
            imageView.layer.shadowRadius = 1
            
            // add profile image to stackview
            membersStackView.addArrangedSubview(imageView)
        }
    }
    
}
