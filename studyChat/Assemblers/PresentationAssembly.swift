//
//  PresentationAssembly.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation
import UIKit

protocol PresentationAssembly {
    func rootViewController() -> UINavigationController
    func profileViewController() -> UIViewController
    func conversationsListViewController() -> UIViewController
    func conversationViewController(channel: DBChannel) -> UIViewController
    func themesViewController() -> UIViewController
    func imageCollectionViewController(delegate: ImageCollectionDelegate) -> UIViewController
}

class PresentationAssemblyImpl: PresentationAssembly {
    
    private let serviceAssembly: ServiceAssembly
    
    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func rootViewController() -> UINavigationController {
        return UINavigationController(rootViewController: conversationsListViewController())
    }
    
    func profileViewController() -> UIViewController {
        let controller = ProfileViewController()
        let view = ProfileViewImpl()
        view.buttonBuilder = serviceAssembly.buttonBuilder
        serviceAssembly.saveLoadService.loadData { [weak controller] in
            switch $0 {
            case .success(let profileData):
                controller?.profileData = profileData
                controller?.fillProfileData()
            case .failure:
                print("error loading profile data")
            }
        }
        controller.view = view
        controller.setupView()
        controller.saveLoadDataManager = serviceAssembly.saveLoadService
        controller.networkService = serviceAssembly.networkService
        controller.serviceAssembly = serviceAssembly
        controller.presentationAssembly = self
        return controller
    }
    
    func conversationsListViewController() -> UIViewController {
        let controller = ConversationsListViewController()
        controller.presentationAssembly = self
        controller.firebaseService = serviceAssembly.firebaseService
        controller.coreDataService = serviceAssembly.coreDataService
        controller.transitionAnimation = TransitionAnimation()
        return controller
    }
    
    func conversationViewController(channel: DBChannel) -> UIViewController {
        let controller = ConversationViewController()
        serviceAssembly.saveLoadService.loadData { [weak controller] in
            switch $0 {
            case .success(let profileData):
                controller?.userName = profileData.name
            case .failure:
                print("error loading profile data")
            }
        }
        controller.channel = channel
        controller.userId = serviceAssembly.firebaseService.getUserId()
        controller.firebaseService = serviceAssembly.firebaseService
        controller.coreDataService = serviceAssembly.coreDataService
        controller.networkService = serviceAssembly.networkService
        controller.presentationAssembly = self
        return controller
    }
    
    func themesViewController() -> UIViewController {
        let controller = ThemesViewControllerSwift()
        controller.delegate = conversationsListViewController()
        controller.buttonBuilder = serviceAssembly.buttonBuilder
        controller.serviceAssembly = serviceAssembly
        return controller
    }
    
    func imageCollectionViewController(delegate: ImageCollectionDelegate) -> UIViewController {
        let controller = ImageCollectionViewController()
        controller.networkService = serviceAssembly.networkService
        controller.delegate = delegate
        return controller
    }
}
