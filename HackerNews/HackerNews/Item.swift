//
//  Item.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct Item {
    let title: String
    let user: String
    let score: Int
    let description: String
    var commentList: [Int]
    var comments: [Comment] = []
}
