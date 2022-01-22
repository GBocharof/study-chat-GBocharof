//
//  CoreDataStack.swift
//  studyChat
//
//  Created by Gleb Bocharov on 08.11.2021.
//

import Foundation
import CoreData

protocol CoreDataStack {
    
    var mainQueueContext: NSManagedObjectContext { get set }
    func saveMessageData(data: [Message], channel: DBChannel)
    func saveChannelsData(newData: [Channel])
}

class CoreDataStackImpl: CoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "studyChat")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {}
        }
        return container
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()

    func saveMessageData(data: [Message], channel: DBChannel) {
        let contextChannel = mainQueueContext.object(with: channel.objectID) as? DBChannel
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        guard let messages = try? mainQueueContext.fetch(fetchRequest) else { return }
        for message in data {
            if messages.firstIndex(where: { $0.senderId == message.senderId && $0.created == message.created }) != nil { continue }
            if let managedObject = NSEntityDescription.insertNewObject(forEntityName: "DBMessage", into: mainQueueContext) as? DBMessage {
                managedObject.content = message.content
                managedObject.created = message.created
                managedObject.senderId = message.senderId
                managedObject.senderName = message.senderName
                contextChannel?.addToMessages(managedObject)
            }
        }
        self.saveContext()
    }
    
    func saveChannelsData(newData: [Channel]) {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        guard let channels = try? mainQueueContext.fetch(fetchRequest) else { return }
        if channels.isEmpty {
            if newData.isEmpty {
                // nothing
            } else {
                self.saveNewChannelsData(newData: newData)
            }
        } else {
            if newData.isEmpty {
                self.deleteAllChannelsData(storedData: channels)
            } else {
                self.mergeChannelsData(newData: newData, storedData: channels)
            }
        }
        self.saveContext()
    }
    
    func mergeChannelsData(newData: [Channel], storedData: [DBChannel]) {
        var tmpData = newData
        for channel in storedData {
            if let indexOfChannel = tmpData.firstIndex(where: { $0.identifier == channel.identifier }) {
                let contextChannel = mainQueueContext.object(with: channel.objectID) as? DBChannel
                contextChannel?.lastActivity = tmpData[indexOfChannel].lastActivity
                contextChannel?.lastMessage = tmpData[indexOfChannel].lastMessage
                tmpData.remove(at: indexOfChannel)
                
            } else {
                mainQueueContext.delete(channel)
            }
        }
        saveNewChannelsData(newData: tmpData)
    }
    
    func saveNewChannelsData(newData: [Channel]) {
        for channel in newData {
            let managedObject = DBChannel(context: mainQueueContext)
            managedObject.identifier = channel.identifier
            managedObject.lastActivity = channel.lastActivity
            managedObject.lastMessage = channel.lastMessage
            managedObject.name = channel.name
        }
    }
    
    func deleteAllChannelsData(storedData: [DBChannel]) {
        for channel in storedData {
            mainQueueContext.delete(channel)
        }
    }
    
    func saveContext() {
        if mainQueueContext.hasChanges {
            do {
                try mainQueueContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
