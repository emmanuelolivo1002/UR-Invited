//
//  CurrentMembersInGroupTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 13/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class CurrentMembersInGroupTableViewCell: UITableViewCell {
    
    // Outlets for the tableview
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var guestOptionButton: UIButton!
    @IBOutlet weak var userProfileIconImage: UIImageView!
    
    @IBOutlet weak var inviteLabel: UILabel!
    
    @IBOutlet weak var guestTypeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    
    func configureCell(user: User, isSelected: Bool , showCurrentGuests: Bool) {
        self.userNameLabel.text = user.username
        self.idLabel.text = user.uid
        
        if user.username == "Fanatics" {
            
            guestTypeLabel.text = "Premium guest"
        } else {
            guestTypeLabel.text = ""
            
        }
        
        userProfileIconImage.sd_setImage(with: URL(string: user.profilePicture), completed: nil)
        
        if showCurrentGuests {
            inviteLabel.isHidden = true
            guestOptionButton.isHidden = false
        } else {
            
            if isSelected {
                inviteLabel.textColor = #colorLiteral(red: 0.9294117647, green: 0.568627451, blue: 0.2078431373, alpha: 1)
                inviteLabel.text = "INVITED"
            } else {
                inviteLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.662745098, blue: 0.7176470588, alpha: 1)
                inviteLabel.text = "INVITE"
            }
            
            inviteLabel.isHidden = false
            guestOptionButton.isHidden = true
        }
    }
    
    
    
}

