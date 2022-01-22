//
//  ServiceAssembly.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation

protocol ServiceAssembly {
    
    var saveLoadService: SaveLoadService { get }
    var firebaseService: FirebaseService { get }
    var buttonBuilder: UIButtonBuilder { get }
    var coreDataService: CoreDataService { get }
    var networkService: NetworkService { get }
    var animationService: AnimationService { get }
    
}

class ServiceAssemblyImpl: ServiceAssembly {
        
    private let coreAssembly: CoreAssembly
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var saveLoadService: SaveLoadService = SaveLoadServiceImpl(saveLoadDataCore: coreAssembly.saveLoadDataCore)
    lazy var firebaseService: FirebaseService = FirebaseServiceImpl(firebaseCore: coreAssembly.firebaseCore)
    lazy var buttonBuilder: UIButtonBuilder = UIButtonBuilderImpl()
    lazy var coreDataService: CoreDataService = CoreDataServiceImpl(coreDataStack: coreAssembly.coreDataStack)
    lazy var networkService: NetworkService = NetworkServiceImpl(networkCore: coreAssembly.networkCore)
    lazy var animationService: AnimationService = AnimationServiceImpl(animationCore: coreAssembly.animationCore)
    
}
