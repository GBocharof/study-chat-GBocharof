//
//  SaveLoadDataService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation

protocol SaveLoadService {
  
    func loadData(completion: @escaping (Result<ProfileData, Error>) -> Void)
    func saveData(profileData: ProfileData, completion: @escaping (Result<ProfileData, Error>) -> Void)
    var saveLoadDataCore: SaveLoadDataCore { get set }
}

class SaveLoadServiceImpl: SaveLoadService {
    
    var saveLoadDataCore: SaveLoadDataCore
    
    init(saveLoadDataCore: SaveLoadDataCore) {
        self.saveLoadDataCore = saveLoadDataCore
    }
    
    private let queue = DispatchQueue.global(qos: .utility)
    
    func loadData(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        queue.async {
            self.saveLoadDataCore.loadData { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
    
    func saveData(profileData: ProfileData, completion: @escaping (Result<ProfileData, Error>) -> Void) {
        queue.async {
            self.saveLoadDataCore.saveData(profileData: profileData) { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
}
