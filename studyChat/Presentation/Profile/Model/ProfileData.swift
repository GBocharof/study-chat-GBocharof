//
//  ProfileData.swift
//  studyChat
//
//  Created by Gleb Bocharov on 19.10.2021.
//

import UIKit

public class ProfileData {
    
    var name: String
    var info: String
    var photo: String
    
    var dictionary: NSDictionary {
            let dictionary = NSDictionary(objects: [name, info, photo], forKeys: ["name" as NSCopying, "info" as NSCopying, "photo" as NSCopying])
            return dictionary
        }
    
    init(name: String = "", info: String = "", photo: String = "") {
        self.name = name
        self.info = info
        self.photo = photo
    }
    
    convenience init(dictionary: NSDictionary) {
      
        var name: String
        var info: String
        var photo: String
      
            if let nameInit = dictionary.object(forKey: "name") as? String {name = nameInit} else {name = ""}
            if let infoInit = dictionary.object(forKey: "info") as? String {info = infoInit} else {info = ""}
            if let photoInit = dictionary.object(forKey: "photo") as? String {photo = photoInit} else {photo = ""}

        self.init(name: name, info: info, photo: photo)
        }
    
}
