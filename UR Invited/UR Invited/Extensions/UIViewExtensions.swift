//
//  UIViewExtensions.swift
//  UR Invited
//
//  Created by Emmanuel Olivo on 26/02/18.
//  Copyright © 2018 MJ Invited LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func bindToKeyboard () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    // Objective C function to set animation
    @objc func keyboardWillChange(_ notification: NSNotification) {
        
        // Get duration of keyboard animation
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        // Get curve of keyboard animation for options
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        // Get keyboard beginning and end frame to calculate deltaY for animation
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        // animate view with previous values
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            
            // Add deltaY to origin y position
            self.frame.origin.y += deltaY
            
        }, completion: nil)
        
        
    }
    
}
