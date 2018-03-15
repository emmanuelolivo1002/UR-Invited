//
//  RoundImage.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 8/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
}
