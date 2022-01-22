//
//  NetworkCore.swift
//  studyChat
//
//  Created by Gleb Bocharov on 23.11.2021.
//

import Foundation

protocol NetworkCore {
    func log(_ msg: Any, isError: Bool)
}

class NetworkCoreImpl: NetworkCore {
    func log(_ msg: Any, isError: Bool = true) {
        print(isError ? "Error🥸" : "Success💪")
        print(msg)
        print()
    }
}

struct Consts {
    static let URLString = "https://pixabay.com/api/"
    static let apiKey: String = {
        guard let apiKey = Bundle.main.infoDictionary?["PIXABAY_API_KEY"] as? String else {
            print("API key not found")
            return ""
        }
        return apiKey
    }()
    static let resultsPerPage = "100"
}

enum MyError: Error {
    case format
    case decode
    case invalidURL
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .format:
            return "Received neither error nor data"
        case .decode:
            return "Got data in unexpected format, it might be error description"
        case .invalidURL:
            return "URL is incorrect :("
        }
    }
}
