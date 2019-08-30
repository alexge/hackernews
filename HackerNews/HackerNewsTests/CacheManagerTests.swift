//
//  CacheManagerTests.swift
//  HackerNewsTests
//
//  Created by Alexander Ge on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

@testable import HackerNews
import XCTest

class CacheManagerTests: XCTestCase {

    func testCacheDirectoryExists() {
        // Arrange / Act
        var manager = CacheManager()
        try? FileManager.default.removeItem(at: manager.exposedCacheDirectory)
        manager = CacheManager()
       
       // Assert
        var x: ObjCBool = true
        XCTAssertTrue(FileManager.default.fileExists(atPath: manager.exposedCacheDirectory.path, isDirectory: &x))
    }
    
    func testLoadSavedItem_ShouldLoadFromCache() {
        // Arrange
        let manager = CacheManager()
        let item = Item(id: 1, title: "title", user: "Boogie", score: 1, description: "story", commentList: [], comments: [])
        
        // Act
        manager.saveToCache(item: item)
        let loadedItem = manager.loadFromCache(itemID: "1")
        
        // Assert
        guard let loaded = loadedItem else {
            XCTFail()
            return
        }
        XCTAssertEqual(loaded.title, "title")
        XCTAssertEqual(loaded.user, "Boogie")
        XCTAssertEqual(loaded.score, 1)
        XCTAssertEqual(loaded.description, "story")
    }
    
    func testLoadUnsavedItem_ShouldReturnNil() {
        // Arrange
        let manager = CacheManager()
        
        // Act
        let item = manager.loadFromCache(itemID: "hello")
        
        // Assert
        XCTAssertNil(item)
    }
}
