//
//  ReceivedMessageTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 2/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class ReceivedMessageTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Constraints Outlets
    @IBOutlet weak var messageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleImageHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: Functions
    
    func configureCell(messageContent: String, username: String, profileImage: UIImage) {
        
        // Set up profile image 
        profileImageView.image = profileImage
        
        // Set up username
        usernameLabel.text = username
        
        
        // Set up message content
        messageTextView.text = messageContent
        
        
        // Set max size for bubble and options
        let size = CGSize(width: 180, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        // Get estimated size of textview
        let textViewEstimatedFrame = NSString(string: messageContent).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.init(name: "OpenSans-Regular", size: 16)!], context: nil)
        
        let estimatedFrame = textViewEstimatedFrame
        
        
        // Set height of message view
        messageViewHeightConstraint.constant = estimatedFrame.height + 30
        
        // set position and width of messageView
        
        print("estimated frame Width: \(estimatedFrame.width)\nestimated frame Heigth: \(estimatedFrame.height)\n" )
        
        messageViewWidthConstraint.constant = estimatedFrame.width + 50
     
        
        // Create bubble and set image with insets
        guard let image = UIImage(named: "chat_bubble_received") else { return }
        bubbleImageView.image = image
            .resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20), resizingMode: .stretch)
        
        
        
        // Set a different color of bubble if brand
        if username == "Fanatics" {
            bubbleImageView.image = bubbleImageView.image?.withRenderingMode(.alwaysTemplate)
            bubbleImageView.tintColor = #colorLiteral(red: 0.8586958768, green: 0.2255439, blue: 0.1976175587, alpha: 1)
            messageTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            bubbleImageView.tintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            messageTextView.textColor = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        }
        
        // Set shadow for bubble
        bubbleImageView.layer.shadowColor = UIColor.black.cgColor
        bubbleImageView.layer.shadowOpacity = 0.1
        bubbleImageView.layer.shadowOffset = CGSize.zero
        bubbleImageView.layer.shadowRadius = 3
        
        // Set bubble height
        bubbleImageHeightConstraint.constant = messageViewHeightConstraint.constant
        
        
    }
}
