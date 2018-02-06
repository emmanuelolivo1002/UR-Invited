//
//  NoticeTableViewCell.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeMessageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set round corners
        noticeMessageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
    
}
