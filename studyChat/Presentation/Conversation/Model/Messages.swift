//
//  Messages.swift
//  studyChat
//
//  Created by Gleb Bocharov on 04.10.2021.
//

import UIKit
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
    }
}

extension Message {
    init(dictionary: NSDictionary) {
        
        var content: String
        var senderId: String
        var senderName: String
        var created: Date
        
        if let contentInit = dictionary.object(forKey: "content") as? String {
            content = contentInit
        } else { content = "" }
        
        if let senderIdInit = dictionary.object(forKey: "senderID") as? String {
            senderId = senderIdInit
        } else { senderId = "" }
        
        if let senderNameInit = dictionary.object(forKey: "senderName") as? String {
            senderName = senderNameInit
        } else { senderName = "" }
        
        if let timeStamp = dictionary.object(forKey: "created") as? Timestamp {
            let createdInit = Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
            created = createdInit
        } else { created = Date() }
        
        self.init(content: content, created: created, senderId: senderId, senderName: senderName)
    }
}
