//
//  SentMessageTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 28/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class SentMessageTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    // Constraint Outlets
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: Functions
    func configureCell(messageContent: String) {

        // Set content of text
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
        
        
        
        // :)
        
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
        
            
        
    }
    
}
