//
//  RequestPerformer.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

class RequestPerformer {
    
    private let baseURL: String = "https://hacker-news.firebaseio.com/v0/"
    private let topStories: String = "topstories"
    private let itemPath: String = "item/"
    private let jsonQuery: String = ".json?print=pretty"
    
    func fetchTopItemIds(successHandler: @escaping (([Int]) -> Void)) {
        let url = URL(string: baseURL + topStories + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var serializedJSONResponse: Any
            do {
                serializedJSONResponse = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                return
            }
            
            guard let serializedJSONArray = serializedJSONResponse as? [Int] else { return }
            
            successHandler(serializedJSONArray)
        }
        task.resume()
    }
    
    func fetchItemDetail(itemID: String, successHandler: @escaping ((Item?) -> Void)) {
        let url = URL(string: baseURL + itemPath + itemID + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var serializedJSONResponse: Any
            do {
                serializedJSONResponse = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                return
            }
            
            guard let serializedJSONArray = serializedJSONResponse as? [String:Any] else { return }
            
            let jsonParser = JSONParser()
            let item = jsonParser.itemFrom(json: serializedJSONArray)
            
            successHandler(item)
        }
        task.resume()
    }
    
    func fetchComment(commentID: String, successHandler: @escaping ((Comment?) -> Void)) {
        let url = URL(string: baseURL + itemPath + commentID + jsonQuery)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var serializedJSONResponse: Any
            do {
                serializedJSONResponse = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                return
            }
            
            guard let serializedJSONArray = serializedJSONResponse as? [String:Any] else { return }
            
            let jsonParser = JSONParser()
            let comment = jsonParser.commentFrom(json: serializedJSONArray)
            
            successHandler(comment)
        }
        task.resume()
    }
}
