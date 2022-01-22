//
//  ProfileView.swift
//  studyChat
//
//  Created by Gleb Bocharov on 17.11.2021.
//

import UIKit

class ProfileViewImpl: UIView {
    var buttonBuilder: UIButtonBuilder!
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        header.layer.cornerRadius = 18
        header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel(text: "My Profile", textColor: .black, font: .boldSystemFont(ofSize: 26))
        return title
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultContact")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 100
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Name Surname"
        name.textAlignment = .center
        name.font = .boldSystemFont(ofSize: 24)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        name.accessibilityIdentifier = "ProfileNameTextField"
        return name
    }()
    
    lazy var infoTextView: UITextView = {
        let info = UITextView()
        info.textContainer.maximumNumberOfLines = 2
        info.text = "Type some info"
        info.isScrollEnabled = false
        info.textAlignment = .left
        info.font = .systemFont(ofSize: 16)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.accessibilityIdentifier = "ProfileInfoTextView"
        return info
    }()

    lazy var closeButton: UIButton = {
        let button = buttonBuilder.buildDefaultButtonWithoutBackground(with: "Close", fontSize: 17)
        return button
    }()
    
    lazy var editImageButton: UIButton = {
        let button = buttonBuilder.buildDefaultButtonWithoutBackground(with: "Edit", fontSize: 16)
        return button
    }()
    
    lazy var profileEditButton: UIButton = {
        let button = buttonBuilder.buildDefaultButtonWithBackground(with: "Edit", fontSize: 18)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = buttonBuilder.buildDefaultButtonWithBackground(with: "Cancel", fontSize: 18)
        return button
    }()
    
    lazy var saveGCDButton: UIButton = {
        let button = buttonBuilder.buildDefaultButtonWithBackground(with: "Save", fontSize: 18)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        let transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        indicator.transform = transform
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(headerView)
        let guide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: guide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
        ])
        
        headerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -17)
        ])
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 7),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        contentView.addSubview(editImageButton)
        NSLayoutConstraint.activate([
            editImageButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor),
            editImageButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor),
            editImageButton.heightAnchor.constraint(equalToConstant: 40),
            editImageButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 26),
            nameTextField.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        contentView.addSubview(infoTextView)
        NSLayoutConstraint.activate([
            infoTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 26),
            infoTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoTextView.widthAnchor.constraint(equalToConstant: 218)
        ])
        
        contentView.addSubview(saveGCDButton)
        NSLayoutConstraint.activate([
            saveGCDButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveGCDButton.heightAnchor.constraint(equalToConstant: 40),
            saveGCDButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveGCDButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: saveGCDButton.topAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubview(profileEditButton)
        NSLayoutConstraint.activate([
            profileEditButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            profileEditButton.heightAnchor.constraint(equalToConstant: 40),
            profileEditButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileEditButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: 30),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
