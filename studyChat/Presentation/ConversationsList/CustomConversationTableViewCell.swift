//
//  CustomConversationTableViewCell.swift
//  studyChat
//
//  Created by Gleb Bocharov on 04.10.2021.
//

import UIKit

class CustomConversationTableViewCell: UITableViewCell {

    lazy var formatter: DateFormatter = {
        let formatter = Date.dateFormatter
        return formatter
    }()
    
    lazy var contactImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultContact")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: "Name",
                            textColor: .black,
                            font: .boldSystemFont(ofSize: 15))
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(text: "Message",
                            textColor: UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6),
                            font: .systemFont(ofSize: 13))
        label.numberOfLines = 2
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(text: "Date",
                            textColor: UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6),
                            font: .systemFont(ofSize: 15),
                            aligment: .right)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        
        addSubview(contactImage)
        NSLayoutConstraint.activate([
            contactImage.topAnchor.constraint(equalTo: topAnchor, constant: 20.5),
            contactImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contactImage.widthAnchor.constraint(equalToConstant: 44),
            contactImage.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.5),
            nameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.5),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            dateLabel.widthAnchor.constraint(equalToConstant: 50),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 15)
        ])
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 12),
            messageLabel.heightAnchor.constraint(equalToConstant: 36),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func configure(with model: DBChannel) {
        
        let currentDate = Date(timeIntervalSinceNow: 0)
        
        nameLabel.text = model.name
        if let message = model.lastMessage {
            messageLabel.font = UIFont.systemFont(ofSize: 13)
            messageLabel.text = message
            if let date = model.lastActivity {
                formatter.dateFormat = Calendar.current.isDate(date, inSameDayAs: currentDate) ? "HH:mm" : "dd MMM"
                dateLabel.text = formatter.string(from: date)
            } else {
                dateLabel.text = ""
            }
        } else {
            messageLabel.text = "no messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
            dateLabel.text = ""
        }
    }
    
}
