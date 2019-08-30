//
//  MockURLSession.swift
//  HackerNewsTests
//
//  Created by Alexander Ge on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

class MockURLSession<T: Codable>: URLSession {
    private var object: T
    
    init(objectToReturnAsData object: T) {
        self.object = object
        super.init()
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockDataTask { [weak self] in
            completionHandler(try? JSONEncoder().encode(self?.object), nil, nil)
        }
    }
}

class MockDataTask: URLSessionDataTask {
    let handler: () -> Void
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    override func resume() {
        handler()
    }
}
