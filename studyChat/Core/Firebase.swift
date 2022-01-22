//
//  Firebase.swift
//  studyChat
//
//  Created by Gleb Bocharov on 25.10.2021.
//

import UIKit
import Firebase

protocol Firebase {
    func getUniqueDeviceIdentifierAsString() -> String
    func getMessagesCollection(channelId: String) -> CollectionReference
    func getChannelsCollection() -> CollectionReference
    func getChannelDocument(channelId: String) -> DocumentReference
    func deleteDocument(_ document: DocumentReference)
    func addDocument(to reference: CollectionReference, document: [String: Any])
    func addChannelsListener(for reference: CollectionReference, completion: @escaping ([Channel]) -> Void)
    func addMessagesListener(for reference: CollectionReference, completion: @escaping ([Message]) -> Void)
}

class FirebaseImpl: Firebase {
    
    func addDocument(to reference: CollectionReference, document: [String: Any]) {
        reference.addDocument(data: document) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func addChannelsListener(for reference: CollectionReference, completion: @escaping ([Channel]) -> Void) {
        
        reference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                var channelsData: [Channel] = []
                for document in snapshot.documents {
                    let newChannel = Channel(identifier: document.documentID,
                                             dictionary: document.data() as NSDictionary)
                    channelsData.append(newChannel)
                }
                completion(channelsData)
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func addMessagesListener(for reference: CollectionReference, completion: @escaping ([Message]) -> Void) {
        reference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                var messagesData: [Message] = []
                for document in snapshot.documents {
                    let newMessage = Message(dictionary: document.data() as NSDictionary)
                    messagesData.append(newMessage)
                }
                completion(messagesData)
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    lazy var db: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()
    
    lazy var reference = db.collection("channels")
    
    func getUniqueDeviceIdentifierAsString() -> String {
        
        let strApplicationUUID = UIDevice.current.identifierForVendor?.uuidString
        if let UserId: String = strApplicationUUID {
            return UserId
        }
        return ""
    }

    func getMessagesCollection(channelId: String) -> CollectionReference {
        return reference.document(channelId).collection("messages")
    }
    
    func getChannelsCollection() -> CollectionReference {
        return reference
    }
    
    func getChannelDocument(channelId: String) -> DocumentReference {
        return reference.document(channelId)
    }
    
    func deleteDocument(_ document: DocumentReference) {
        document.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            }
        }
    }
}
