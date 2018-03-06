//
//  FriendsInvitationTableViewCell.swift
//  UR Invited
//
//  Created by Valley Technical Academy on 2/28/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class FriendsInvitationTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var typeOfMember: UILabel!
    @IBOutlet weak var invitedLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    // MARK: Functions
    func configureCell(username: String, isSelected: Bool) {
        self.usernameLabel.text = username
        
        if username == "Fanatics" {
            profileImage.image = UIImage(named: "fanatics-icon")
            typeOfMember.text = "Premium guest"
        } else {
            typeOfMember.text = ""
            profileImage.image = UIImage(named: "profile_icon")
        }
        
        if isSelected {
            invitedLabel.textColor = #colorLiteral(red: 0.9294117647, green: 0.568627451, blue: 0.2078431373, alpha: 1)
            invitedLabel.text = "INVITED"
        } else {
            invitedLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.662745098, blue: 0.7176470588, alpha: 1)
            invitedLabel.text = "INVITE"
        }
        
    }
    
    
}
