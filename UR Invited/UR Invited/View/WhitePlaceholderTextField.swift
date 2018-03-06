//
//  WhitePlaceholderTextField.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 5/03/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

class WhitePlaceholderTextField: UITextField {

    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }

    // Set up color for placeholder text
    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
    }
}
