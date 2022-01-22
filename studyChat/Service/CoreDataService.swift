//
//  CoreDataService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 19.11.2021.
//

import Foundation
import CoreData

protocol CoreDataService {
    func saveChannelsData(newData: [Channel])
    func saveMessagesData(data: [Message], channel: DBChannel)
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>)
    func messagesFRC(channelId: String) -> NSFetchedResultsController<DBMessage>
    func channelsFRC() -> NSFetchedResultsController<DBChannel>
    
}

class CoreDataServiceImpl: CoreDataService {
    func channelsFRC() -> NSFetchedResultsController<DBChannel> {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: coreDataStack.mainQueueContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func messagesFRC(channelId: String) -> NSFetchedResultsController<DBMessage> {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", channelId)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: coreDataStack.mainQueueContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func saveChannelsData(newData: [Channel]) {
        coreDataStack.saveChannelsData(newData: newData)
    }
    
    func saveMessagesData(data: [Message], channel: DBChannel) {
        coreDataStack.saveMessageData(data: data, channel: channel)
    }
    
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>) {
        do {
            try frc.performFetch()
        } catch {
            print("error fetching data: \(error)")
        }
    }
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
}
