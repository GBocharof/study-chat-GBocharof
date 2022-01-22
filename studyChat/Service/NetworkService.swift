//
//  NetworkService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 24.11.2021.
//

import Foundation
import UIKit

protocol NetworkService {
    
    @available(iOS 15.0.0, *)
    func sendRequest() async throws -> Response
    @available(iOS 15.0.0, *)
    func sendImageRequest(url: String) async throws -> UIImage
}

class NetworkServiceImpl: NetworkService {
   
    let networkCore: NetworkCore
    
    init(networkCore: NetworkCore) {
        self.networkCore = networkCore
    }
    
    @available(iOS 15.0.0, *)
    func sendRequest() async throws -> Response {
        guard let url = URL(string: createURLString()) else {
            throw MyError.invalidURL
        }
        let request = URLRequest(url: url, timeoutInterval: 15)
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(Response.self, from: data)
        return response
    }
    
    @available(iOS 15.0.0, *)
    func sendImageRequest(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw MyError.invalidURL }
        let request = URLRequest(url: url, timeoutInterval: 15)
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        guard let image = UIImage(data: data) else { throw MyError.format }
        return image
    }
    
    func createURLString() -> String {
        let string: String = "\(Consts.URLString)?key=\(Consts.apiKey)&per_page=\(Consts.resultsPerPage)"
        return string
    }
}
