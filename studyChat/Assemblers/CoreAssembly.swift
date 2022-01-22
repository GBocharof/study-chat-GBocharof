//
//  CoreAssembly.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation

protocol CoreAssembly {
    
    var saveLoadDataCore: SaveLoadDataCore { get }
    var firebaseCore: Firebase { get }
    var coreDataStack: CoreDataStack { get }
    var networkCore: NetworkCore { get }
    var animationCore: AnimationCore { get }
}

class CoreAssemblyImpl: CoreAssembly {
    
    lazy var profileData: ProfileData = {
        let profileData = ProfileData(name: "", info: "", photo: "")
        return profileData
    }()
    
    lazy var saveLoadDataCore: SaveLoadDataCore = SaveLoadDataCoreImpl(profileData: profileData)
    lazy var firebaseCore: Firebase = FirebaseImpl()
    lazy var coreDataStack: CoreDataStack = CoreDataStackImpl()
    lazy var networkCore: NetworkCore = NetworkCoreImpl()
    lazy var animationCore: AnimationCore = AnimationCoreImpl()
}
