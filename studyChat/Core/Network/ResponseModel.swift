//
//  ResponseModel.swift
//  studyChat
//
//  Created by Gleb Bocharov on 24.11.2021.
//

import Foundation

struct Response: Codable {
    let hits: [ResponseData]
}

struct ResponseData: Codable {
    let webformatURL: String
    let previewURL: String
}
