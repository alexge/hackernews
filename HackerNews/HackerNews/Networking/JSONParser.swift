//
//  JSONParser.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

class JSONParser {
    
    func parse<T>(type: T.Type, from json: Any) -> T? {
        if type == Item.self, let json = json as? [String:Any] {
            return item(from: json) as? T
        } else if type == Comment.self, let json = json as? [String:Any] {
            return comment(from: json) as? T
        } else if type == [Int].self, let json = json as? [Int] {
            return json as? T
        } else {
            return nil
        }
    }
    
    private func item(from json: [String:Any]) -> Item? {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let user = json["by"] as? String,
            let score = json["score"] as? Int,
            let type = json["type"] as? String
            else {
                return nil
        }
        let comments = json["kids"] as? [Int] ?? []
        
        return Item(id: id, title: title, user: user, score: score, description: type, commentList: comments, comments: [])
    }
    
    private func comment(from json: [String:Any]) -> Comment? {
        guard let id = json["id"] as? Int,
            let parent = json["parent"] as? Int,
            let text = json["text"] as? String
            else {
                return nil
        }
        
        return Comment(id: id, parent: parent, text: text, level: 0)
    }
}
