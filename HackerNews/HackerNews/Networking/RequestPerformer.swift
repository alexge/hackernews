//
//  RequestPerformer.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

protocol RequestPerformable: class {
    func fetchTopItemIds(successHandler: @escaping (([Int]) -> Void))
    func fetchItemDetail(itemID: String, successHandler: @escaping ((Item?) -> Void))
    func fetchComment(commentID: String, successHandler: @escaping ((Comment?) -> Void))
}

final class RequestPerformer: RequestPerformable {
    
    private let baseURL: String = "https://hacker-news.firebaseio.com/v0/"
    private let topStories: String = "topstories"
    private let itemPath: String = "item/"
    private let jsonQuery: String = ".json?print=pretty"
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchTopItemIds(successHandler: @escaping (([Int]) -> Void)) {
        let url = URL(string: baseURL + topStories + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let itemList = self?.decodeJSON(data: data, error: error, expectedType: [Int].self) {
                successHandler(itemList)
            }
        }
        task.resume()
    }
    
    func fetchItemDetail(itemID: String, successHandler: @escaping ((Item?) -> Void)) {
        let url = URL(string: baseURL + itemPath + itemID + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let item = self?.decodeJSON(data: data, error: error, expectedType: Item.self) {
                successHandler(item)
            }
        }
        task.resume()
    }
    
    func fetchComment(commentID: String, successHandler: @escaping ((Comment?) -> Void)) {
        let url = URL(string: baseURL + itemPath + commentID + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let comment = self?.decodeJSON(data: data, error: error, expectedType: Comment.self) {
                successHandler(comment)
            }
        }
        task.resume()
    }
    
    private func decodeJSON<T>(data: Data?, error: Error?, expectedType: T.Type) -> T? {
        guard let data = data, error == nil else { return nil }
        
        var serializedJSONResponse: Any
        do {
            serializedJSONResponse = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return nil
        }
        
        let jsonParser = JSONParser()
        return jsonParser.parse(type: T.self, from: serializedJSONResponse)
    }
}
