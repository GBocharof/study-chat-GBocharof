//
//  UIHelperCoreService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation
import UIKit

protocol UIButtonBuilder {
    func buildDefaultButtonWithBackground(with title: String, fontSize: CGFloat) -> UIButton
    func buildDefaultButtonWithoutBackground(with title: String, fontSize: CGFloat) -> UIButton
}

class UIButtonBuilderImpl: UIButtonBuilder {
    
    func buildDefaultButtonWithBackground(with title: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func buildDefaultButtonWithoutBackground(with title: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
