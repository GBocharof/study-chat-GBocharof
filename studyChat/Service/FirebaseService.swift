//
//  FirebaseService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation

protocol FirebaseService {
    func addChannel(channelDict: [String: Any])
    func deleteChannel(channelId: String)
    func addMessage(channelId: String, messageDict: [String: Any])
    func listenForChannels(completion: @escaping ([Channel]) -> Void)
    func listenForMessages(channelId: String, completion: @escaping ([Message]) -> Void)
    func getUserId() -> String
}

class FirebaseServiceImpl: FirebaseService {
    func getUserId() -> String {
        return firebaseCore.getUniqueDeviceIdentifierAsString()
    }
    
    func addChannel(channelDict: [String: Any]) {
        firebaseCore.addDocument(to: firebaseCore.getChannelsCollection(), document: channelDict)
    }
    
    func deleteChannel(channelId: String) {
        firebaseCore.deleteDocument(firebaseCore.getChannelDocument(channelId: channelId))
    }
    
    func addMessage(channelId: String, messageDict: [String: Any]) {
        let collection = firebaseCore.getMessagesCollection(channelId: channelId)
        firebaseCore.addDocument(to: collection, document: messageDict)
    }
    
    func listenForChannels(completion: @escaping ([Channel]) -> Void) {
        firebaseCore.addChannelsListener(for: firebaseCore.getChannelsCollection(),
                                            completion: completion)
    }
    
    func listenForMessages(channelId: String, completion: @escaping ([Message]) -> Void) {
        firebaseCore.addMessagesListener(for: firebaseCore.getMessagesCollection(channelId: channelId),
                                            completion: completion)
    }

    let firebaseCore: Firebase
    
    init(firebaseCore: Firebase) {
        self.firebaseCore = firebaseCore
    }
}
