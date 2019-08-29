//
//  Comment.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct Comment {
    let id: Int
    let parent: Int
    let text: String
    var level: Int
}
