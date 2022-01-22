//
//  SaveLoadDataCore.swift
//  studyChat
//
//  Created by Gleb Bocharov on 19.10.2021.
//

import UIKit

protocol SaveLoadDataCore {
  
    var profileData: ProfileData { get set }
    func loadData(completion: @escaping (Result<ProfileData, Error>) -> Void)
    func saveData(profileData: ProfileData, completion: @escaping (Result<ProfileData, Error>) -> Void)
    
}

class SaveLoadDataCoreImpl: SaveLoadDataCore {
    
    var profileData: ProfileData
    
    init(profileData: ProfileData) {
        self.profileData = profileData
    }
    
    func saveData(profileData: ProfileData, completion: @escaping (Result<ProfileData, Error>) -> Void) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("data.plist")
            try profileData.dictionary.write(to: fileURL)
            completion(.success(profileData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadData(completion: @escaping (Result<ProfileData, Error>) -> Void) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data.plist")
            
            if let loadData = NSDictionary(contentsOf: fileURL) {
                profileData = ProfileData(dictionary: loadData)
                completion(.success(profileData))
            } else {
                completion(.success(profileData))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
