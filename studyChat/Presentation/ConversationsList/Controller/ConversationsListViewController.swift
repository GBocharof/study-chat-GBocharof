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
        
        let addChannelItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alertAddChannel))
        
        let profileButton = UIBarButtonItem(image: UIImage(named: "defaultContact")?.withRenderingMode(.alwaysOriginal),
                                            style: .plain,
                                            target: self,
                                            action: #selector(profileImageTapped))
        profileButton.accessibilityIdentifier = "ProfileButton"
        
        navigationItem.rightBarButtonItems = [addChannelItem, profileButton]
        
        let themeButton = UIBarButtonItem(title: "Themes", style: .plain, target: self, action: #selector(themeButtonTapped))
        navigationItem.leftBarButtonItem = themeButton
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
        let controller = presentationAssembly.profileViewController()
        controller.modalTransitionStyle = .flipHorizontal
//        controller.transitioningDelegate = self
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc
    func themeButtonTapped() {
        guard let presentationAssembly = presentationAssembly else { return }
        let controller = presentationAssembly.themesViewController()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc
    func alertAddChannel() {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField: UITextField) in
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
        present(alertController, animated: true)
    }
}
