//
//  ThemesViewControllerSwift.swift
//  studyChat
//
//  Created by Gleb Bocharov on 14.10.2021.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    var buttonBuilder: UIButtonBuilder!
    var delegate: UIViewController?
    var serviceAssembly: ServiceAssembly?
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        header.layer.cornerRadius = 18
        header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var closeButton: UIButton = {
        let close = buttonBuilder.buildDefaultButtonWithoutBackground(with: "Close", fontSize: 17)
        close.addTarget(self, action: #selector(tapOnClose), for: .touchUpInside)
        return close
    }()
    
    lazy var theme1Button: UIButton = {
        let theme = buttonBuilder.buildDefaultButtonWithBackground(with: "Theme 1", fontSize: 16)
        theme.addTarget(self, action: #selector(tapOnTheme1), for: .touchUpInside)
        return theme
    }()
    
    lazy var theme2Button: UIButton = {
        let theme = buttonBuilder.buildDefaultButtonWithBackground(with: "Theme 2", fontSize: 16)
        theme.addTarget(self, action: #selector(tapOnTheme2), for: .touchUpInside)
        return theme
    }()
    
    lazy var theme3Button: UIButton = {
        let theme = buttonBuilder.buildDefaultButtonWithBackground(with: "Theme 3", fontSize: 16)
        theme.addTarget(self, action: #selector(tapOnTheme3), for: .touchUpInside)
        return theme
    }()
    
    var changeTheme: ((UIColor) -> Void) = ({ (_: UIColor) -> Void in
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        setConstraint()
        
        changeTheme = ({ (selectedTheme: UIColor) -> Void in
            self.view.backgroundColor = selectedTheme
        })
    }
    
    @objc
    func tapOnClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func tapOnTheme1() {
        changeTheme(UIColor.green)
    }
    
    @objc
    func tapOnTheme2() {
        changeTheme(UIColor.brown)
    }
    
    @objc
    func tapOnTheme3() {
        changeTheme(UIColor.orange)
    }
    
    func setConstraint() {
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -4),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        headerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15)
        ])
        
        view.addSubview(theme1Button)
        NSLayoutConstraint.activate([
            theme1Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theme1Button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -95),
            theme1Button.heightAnchor.constraint(equalToConstant: 40),
            theme1Button.widthAnchor.constraint(equalToConstant: 195)
        ])
        
        view.addSubview(theme2Button)
        NSLayoutConstraint.activate([
            theme2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theme2Button.topAnchor.constraint(equalTo: theme1Button.bottomAnchor, constant: 40),
            theme2Button.heightAnchor.constraint(equalToConstant: 40),
            theme2Button.widthAnchor.constraint(equalToConstant: 195)
        ])
        
        view.addSubview(theme3Button)
        NSLayoutConstraint.activate([
            theme3Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theme3Button.topAnchor.constraint(equalTo: theme2Button.bottomAnchor, constant: 40),
            theme3Button.heightAnchor.constraint(equalToConstant: 40),
            theme3Button.widthAnchor.constraint(equalToConstant: 195)
        ])
    }
}
