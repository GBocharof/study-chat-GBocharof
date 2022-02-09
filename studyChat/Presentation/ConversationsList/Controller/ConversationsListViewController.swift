//
//  ConversationsListViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 02.10.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController {
    
    var presentationAssembly: PresentationAssembly?
    var serviceAssembly: ServiceAssembly?
    var firebaseService: FirebaseService?
    var coreDataService: CoreDataService?
    var transitionAnimation: TransitionAnimation?
    var fetchedResultsController: NSFetchedResultsController<DBChannel>!
    
    let cellIdentifier = String(describing: CustomConversationTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomConversationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var addChannelAlert: UIAlertController = {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New channel name..."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let text = alertController.textFields?.first?.text else {
                        return
                    }
            if !text.isEmpty {
                guard let firebaseService = self.firebaseService else { return }
                firebaseService.addChannel(channelDict: ["name": text])
            }
                }))
        
        return alertController
    }()
    
    lazy var profileLogoSize: CGSize = {
       return CGSize(width: 40, height: 40)
    }()
    
    lazy var profileButton: UIButton = {
    let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "defaultContact"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = profileLogoSize.width/2
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        setNavItems()
        
        guard let coreDataService = coreDataService else { return }
        fetchedResultsController = coreDataService.channelsFRC()
        fetchedResultsController.delegate = self
        coreDataService.performFetch(for: fetchedResultsController)
        startListenForChannels(coreDataService: coreDataService)
    }
    
    func startListenForChannels(coreDataService: CoreDataService) {
        guard let firebaseService = firebaseService else { return }
        firebaseService.listenForChannels { channels in
            coreDataService.saveChannelsData(newData: channels)
        }
    }
    
    @objc
    func profileImageTapped() {
        guard let presentationAssembly = presentationAssembly else { return }
        if let controller = presentationAssembly.profileViewController() as? ProfileViewControllerDelegate {
        controller.setDelegate(with: self)
        controller.modalTransitionStyle = .flipHorizontal
//        controller.transitioningDelegate = self
        navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc
    func themeButtonTapped() {
        guard let presentationAssembly = presentationAssembly else { return }
        let controller = presentationAssembly.themesViewController()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc
    func alertAddChannel() {
        present(addChannelAlert, animated: true)
    }
    
    func setNavItems() {
        let addChannelItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alertAddChannel))
        let themeButton = UIBarButtonItem(title: "Themes", style: .plain, target: self, action: #selector(themeButtonTapped))
        navigationItem.leftBarButtonItem = themeButton
        
        let profileButtonItem = UIBarButtonItem(customView: profileButton)
        
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: profileLogoSize.width),
            profileButton.heightAnchor.constraint(equalToConstant: profileLogoSize.height)
            ])
        navigationItem.rightBarButtonItems = [addChannelItem, profileButtonItem]
        
        updateProfileLogoFromDB()
        
    }
}
