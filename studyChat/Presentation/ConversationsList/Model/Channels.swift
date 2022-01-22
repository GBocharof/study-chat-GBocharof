//
//  Channels.swift
//  studyChat
//
//  Created by Gleb Bocharov on 25.10.2021.
//

import UIKit
import Firebase

struct Channel: Hashable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    init(identifier: String, dictionary: NSDictionary) {
        
        var name: String
        var lastMessage: String?
        var lastActivity: Date?
        
        if let nameInit = dictionary.object(forKey: "name") as? String {
            name = nameInit
        } else { name = "" }
        
        if let lastMessageInit = dictionary.object(forKey: "lastMessage") as? String {
            lastMessage = lastMessageInit
        } else { lastMessage = nil }
        
        if let timeStamp = dictionary.object(forKey: "lastActivity") as? Timestamp {
            let lastActivityInit = Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
            lastActivity = lastActivityInit
        } else { lastActivity = nil }
        
        self.init(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
    }
}
