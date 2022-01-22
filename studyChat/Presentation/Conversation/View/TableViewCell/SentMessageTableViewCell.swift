//
//  SentMessageTableViewCell.swift
//  studyChat
//
//  Created by Gleb Bocharov on 07.10.2021.
//

import UIKit

class SentMessageTableViewCell: UITableViewCell {
    
    var networkService: NetworkService?
    
    lazy var messageViewLeadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 70 / 255, green: 130 / 255, blue: 180 / 255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageMessageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DBMessage, networkService: NetworkService?) {
        self.networkService = networkService
        messageLabel.text = model.content
        messageHaveImage()
    }
    
    func setConstraints() {
        messageViewLeadingConstraint.constant = -16 + (frame.width - 32) / 4
        
        addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageViewLeadingConstraint,
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        messageView.addSubview(bubbleView)
        NSLayoutConstraint.activate([
            bubbleView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor),
            bubbleView.heightAnchor.constraint(equalTo: messageView.heightAnchor),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: messageView.widthAnchor, multiplier: 1)
        ])
        
        bubbleView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5)
        ])
        
        bubbleView.addSubview(imageMessageView)
        NSLayoutConstraint.activate([
            imageMessageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            imageMessageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
            imageMessageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            imageMessageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func messageHaveImage() {
        imageMessageView.image = nil
        guard let text = messageLabel.text else { return }
        if text.hasPrefix("http") {
            if #available(iOS 15.0, *) {
                fetchRequestImage(url: text)
            } else {}
        } else {}
    }
    
    @available(iOS 15.0, *)
    func fetchRequestImage(url: String) {
        Task {
            do {
                guard let networkService = networkService else { return }
                let image = try await networkService.sendImageRequest(url: url)
                setMessageImage(with: image)
            }
        }
    }
    
    func setMessageImage(with image: UIImage) {
        imageMessageView.image = image
    }
    
}
