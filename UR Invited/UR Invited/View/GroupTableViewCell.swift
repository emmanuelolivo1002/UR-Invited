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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countFlag = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countFlag = 0
        for view in membersStackView.arrangedSubviews {
            membersStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    
    // Configure elements in cell wit a Group object
    func configureCell(group: Group, newMesage: Bool) {
        
        membersStackView.isHidden = false
        
        
        
        groupNameLabel.text = group.groupTitle
        
        if newMesage {
            groupNameLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            groupNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        
        numberOfMembersLabel.text =  "\(group.memberCount) members"
        
        
        membersStackViewWidthConstraint.constant = CGFloat(group.memberCount * 32 + (group.memberCount * 3))
        
//        DataService.instance.getAllProfilePictures(forGroup: group) { (returnedImageViewArray) in
//
//            for view in returnedImageViewArray {
//
//                self.membersStackView.insertArrangedSubview(view, at: self.countFlag)
//                self.countFlag += 1
//            }
//
//        }
        
        
        // loop through all members of a group to set the profile image
        for user in group.members {
            

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
                           
                            
                            print("inserting image at index: \(self.membersStackView.arrangedSubviews.count)")
                            self.membersStackView.addArrangedSubview(imageView)
                                
                            
                            

                            print("count: \(self.membersStackView.arrangedSubviews.count), group: \(group.groupTitle), members: \(group.memberCount)")
                        }
                    })
                })
            
        }
            membersStackView.isHidden = false
        
        
        
        
    }
}


