//
//  UILabel.swift
//  studyChat
//
//  Created by Gleb Bocharov on 17.11.2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, textColor: UIColor, font: UIFont?, aligment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = aligment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
