//
//  MessageTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 13/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Constraint Outlets
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(messageContent: String, isSender: Bool, username: String, profilePicture: String) {
        
        
        // Set content of text
        messageTextView.text = messageContent
        
        // Set username
        nameLabel.text = username
        
        // Set profile picture
        profileIconImageView.image = UIImage(named: profilePicture)
        
        
        // Set max size for bubble and options
        let size = CGSize(width: 180, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        // Get estimated size of textview
        let textViewEstimatedFrame = NSString(string: messageTextView.text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.init(name: "OpenSans-Regular", size: 16)!], context: nil)
        
        // Get estimated size of nameLabel
        let nameLabelEstimatedFrame = NSString(string: nameLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.init(name: "OpenSans-Regular", size: 10)!], context: nil)
        
        var estimatedFrame = CGRect()
        if textViewEstimatedFrame.width > nameLabelEstimatedFrame.width {
            estimatedFrame = textViewEstimatedFrame
        } else {
            estimatedFrame = nameLabelEstimatedFrame
        }
        
        
        
        // Set height of message view
        messageViewHeightConstraint.constant = estimatedFrame.height + 30
        
        
        if isSender {
            
            // Hide profile picture and label
            profileIconImageView.isHidden = true
            nameLabel.isHidden = true
            
            // set position and width of messageView
            messageViewRightConstraint.constant = 20
            messageViewLeftConstraint.constant = self.frame.width - (estimatedFrame.width) + 10
            
            
            // Set text color
            messageTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            // Create bubble and set image with insets
            guard let image = UIImage(named: "chat_bubble_sent") else { return }
            bubbleImageView.image = image
                .resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20), resizingMode: .stretch)
            
            // Set shadow for bubble
            bubbleImageView.layer.shadowColor = UIColor.black.cgColor
            bubbleImageView.layer.shadowOpacity = 0.1
            bubbleImageView.layer.shadowOffset = CGSize.zero
            bubbleImageView.layer.shadowRadius = 3
            
            // Set bubble height
            bubbleHeightConstraint.constant = messageViewHeightConstraint.constant
            
            
        } else {
            
            // Show profile picture and label
            profileIconImageView.isHidden = false
            nameLabel.isHidden = false
            
            // set position and width of messageView
            messageViewRightConstraint.constant = self.frame.width - (estimatedFrame.width) - profileIconImageView.frame.width
            messageViewLeftConstraint.constant += profileIconImageView.frame.width
            
            // Set text color
            messageTextView.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
            
            // Create bubble and set image with insets
            guard let image = UIImage(named: "chat_bubble_received") else { return }
            bubbleImageView.image = image
                .resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20), resizingMode: .stretch)
            
            // Set shadow for bubble
            bubbleImageView.layer.shadowColor = UIColor.black.cgColor
            bubbleImageView.layer.shadowOpacity = 0.1
            bubbleImageView.layer.shadowOffset = CGSize.zero
            bubbleImageView.layer.shadowRadius = 3
            
            // Set bubble height
            bubbleHeightConstraint.constant = messageViewHeightConstraint.constant
            
            
        }
    }
}
