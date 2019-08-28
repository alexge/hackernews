//
//  JSONParser.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

class JSONParser {
    
    func itemFrom(json: [String:Any]) -> Item? {
        guard let title = json["title"] as? String,
            let user = json["by"] as? String,
            let score = json["score"] as? Int,
            let type = json["type"] as? String
            else {
                return nil
        }
        let comments = json["kids"] as? [Int] ?? []
        
        return Item(title: title, user: user, score: score, description: type, commentList: comments, comments: [])
    }
    
    func commentFrom(json: [String:Any]) -> Comment? {
        guard let id = json["id"] as? Int,
            let parent = json["parent"] as? Int,
            let text = json["text"] as? String
            else {
                return nil
        }
        
        return Comment(id: id, parent: parent, text: text)
    }
}
