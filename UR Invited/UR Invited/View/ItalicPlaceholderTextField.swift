//
//  ItalicPlaceholderTextField.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 6/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class ItalicPlaceholderTextField: UITextField {

    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    
    // Set up color for placeholder text
    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.font : UIFont.init(name: "OpenSans-Italic", size: 12)!])
        self.attributedPlaceholder = placeholder
    }

}
