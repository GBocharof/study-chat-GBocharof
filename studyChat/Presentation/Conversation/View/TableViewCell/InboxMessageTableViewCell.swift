//
//  InboxMessageTableViewCell.swift
//  studyChat
//
//  Created by Gleb Bocharov on 25.11.2021.
//

import UIKit

class InboxMessageTableViewCell: UITableViewCell {
    
    var networkService: NetworkService?
    
    lazy var messageViewTrailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var senderNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
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
        self.selectionStyle = .none
        let senderName = model.senderName.isEmpty ? "<unknown user>" : model.senderName
        messageLabel.text = model.content
        senderNameLabel.text = senderName
        messageHaveImage()
    }
    
    func setConstraints() {
        messageViewTrailingConstraint.constant = -16 - ((frame.width - 32) / 4)
        
        addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageViewTrailingConstraint
        ])
        
        messageView.addSubview(bubbleView)
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            bubbleView.heightAnchor.constraint(equalTo: messageView.heightAnchor),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: messageView.widthAnchor, multiplier: 1)
        ])
        
        bubbleView.addSubview(senderNameLabel)
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            senderNameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            senderNameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5),
            senderNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        bubbleView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5)
        ])
        
        bubbleView.addSubview(imageMessageView)
        NSLayoutConstraint.activate([
            imageMessageView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor),
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
        messageLabel.isHidden = false
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
            } catch {
                apiNotSupported()
            }
        }
    }
    
    func setMessageImage(with image: UIImage) {
        messageLabel.isHidden = true
        imageMessageView.image = image
    }
    
    func apiNotSupported() {
        guard let text = messageLabel.text else { return }
        messageLabel.text = text + "\n<<API not supported>>"
    }
    
}
