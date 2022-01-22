//
//  ConversationViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 02.10.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
    
    var firebaseService: FirebaseService?
    var coreDataService: CoreDataService?
    var networkService: NetworkService?
    var fetchedResultsController: NSFetchedResultsController<DBMessage>!
    var channel: DBChannel?
    var userName: String?
    var userId: String?
    var presentationAssembly: PresentationAssembly?
    
    let sentCellIdentifier = String(describing: SentMessageTableViewCell.self)
    let inboxCellIdentifier = String(describing: InboxMessageTableViewCell.self)
   
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.register(SentMessageTableViewCell.self, forCellReuseIdentifier: sentCellIdentifier)
        tableView.register(InboxMessageTableViewCell.self, forCellReuseIdentifier: inboxCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var messageTextView: UITextView = {
        let message = UITextView()
        message.text = "Write a message..."
        message.textColor = .gray
        message.isScrollEnabled = false
        message.textAlignment = .left
        message.font = .systemFont(ofSize: 16)
        message.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        message.layer.cornerRadius = 10
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    lazy var sentButton: UIButton = {
        let sent = UIButton()
        sent.setTitle("✅", for: .normal)
        sent.setTitle("☑️", for: .disabled)
        sent.isEnabled = false
        sent.addTarget(self, action: #selector(tapOnSent), for: .touchUpInside)
        sent.translatesAutoresizingMaskIntoConstraints = false
        return sent
    }()
    
    lazy var chooseImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("📷", for: .normal)
        button.addTarget(self, action: #selector(tapOnChooseImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let channel = channel else { return }
        guard let coreDataService = coreDataService else { return }

        view.backgroundColor = .white
        navTitleLabel.text = channel.name
        navigationItem.titleView = navTitleLabel
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupToHideKeyboardOnTapOnView()
        setConstraint()
        registerForKeyboardNotifications()
        fetchedResultsController = coreDataService.messagesFRC(channelId: channel.identifier)
        fetchedResultsController.delegate = self
        coreDataService.performFetch(for: fetchedResultsController)
        startListenForMessages(channel: channel, coreDataService: coreDataService)
    }
    
    func startListenForMessages(channel: DBChannel, coreDataService: CoreDataService) {
        guard let firebaseService = firebaseService else { return }
        firebaseService.listenForMessages(channelId: channel.identifier) { messages in
            coreDataService.saveMessagesData(data: messages, channel: channel)
        }
    }
    
    func setConstraint() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentViewHeightConstraint,
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        contentView.addSubview(messageTextView)
        messageTextView.delegate = self
        NSLayoutConstraint.activate([
            messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            messageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        contentView.addSubview(chooseImageButton)
        NSLayoutConstraint.activate([
            chooseImageButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 10),
            chooseImageButton.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor)
        ])
        
        contentView.addSubview(sentButton)
        NSLayoutConstraint.activate([
            sentButton.leadingAnchor.constraint(equalTo: chooseImageButton.trailingAnchor, constant: 10),
            sentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sentButton.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor)
        ])
        
        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -10)
        ])
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardNotification( notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentViewHeightConstraint.constant = 0
        } else {
            if contentViewHeightConstraint.constant == 0 {
                guard let info = notification.userInfo else { return }
                guard let value: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardScreenEndFrame = value.cgRectValue
                let KeyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
                contentViewHeightConstraint.constant = -(KeyboardViewEndFrame.height - view.safeAreaInsets.bottom)
                tableView.scrollToBottom()
            }
        }
    }
  
    func sentMessage(content: String) {
        guard let firebaseService = firebaseService else { return }
        guard let channel = channel else { return }
        guard let userId = userId else { return }
        let message = Message(content: content,
                              created: Date(),
                              senderId: userId,
                              senderName: userName ?? "unknown user")
        firebaseService.addMessage(channelId: channel.identifier, messageDict: message.toDict)
        messageIsSent()
    }
    
    @objc
    func tapOnSent() {
        sentMessage(content: messageTextView.text)
    }
    
    @objc
    func tapOnChooseImage() {
        guard let presentationAssembly = presentationAssembly else { return }
        let controller = presentationAssembly.imageCollectionViewController(delegate: self)
        self.present(controller, animated: true, completion: nil)
    }
    
    func messageIsSent() {
        messageTextView.text = ""
        setPlaceHolderInfoTextView()
        sentButton.isEnabled = false
        tableView.scrollToBottom()
    }
}
