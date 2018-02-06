//
//  SentMessageTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class SentMessageTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    
    //MARK: Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
