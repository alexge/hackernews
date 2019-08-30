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
        if let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let user = json["by"] as? String,
            let score = json["score"] as? Int,
            let type = json["type"] as? String {
            
            let comments = json["kids"] as? [Int] ?? []
            return Item(id: id, title: title, user: user, score: score, description: type, commentList: comments, comments: [])
            
        } else if let stringid = json["id"] as? String,
            let id = Int(stringid),
            let title = json["title"] as? String,
            let user = json["by"] as? String,
            let stringscore = json["score"] as? String,
            let score = Int(stringscore),
            let type = json["type"] as? String {
            
            return Item(id: id, title: title, user: user, score: score, description: type, commentList: [], comments: [])
        } else {
            return nil
        }
    }
    
    private func comment(from json: [String:Any]) -> Comment? {
        if let id = json["id"] as? Int,
            let parent = json["parent"] as? Int,
            let text = json["text"] as? String {
            
            return Comment(id: id, parent: parent, text: text)
        } else if let stringid = json["id"] as? String,
            let id = Int(stringid),
            let stringparent = json["parent"] as? String,
            let parent = Int(stringparent),
            let text = json["text"] as? String {
        
            return Comment(id: id, parent: parent, text: text)
        } else {
            return nil
        }
    }
}
