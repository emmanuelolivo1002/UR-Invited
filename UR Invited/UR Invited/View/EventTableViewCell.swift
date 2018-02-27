//
//  EventTableViewCell.swift
//  
//
//  Created by Valley Technical Academy on 2/16/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var sportsTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "EventSectionCollectionViewCell", bundle: nil)
        eventCollectionView.register(nib, forCellWithReuseIdentifier: "EventSectionCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
