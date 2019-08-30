//
//  JSONParserTests.swift
//  HackerNewsTests
//
//  Created by Alexander Ge on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

@testable import HackerNews
import XCTest

class JSONParserTests: XCTestCase {

    func testParse_WithTypeStringInt_ShouldReturnNil() {
        // Arrange
        let json = ["hello":"bye"]
        let jsonParser = JSONParser()
        
        // Act
        let intTypeResult = jsonParser.parse(type: Int.self, from: json)
        let stringTypeResult = jsonParser.parse(type: String.self, from: json)
        
        // Assert
        XCTAssertNil(intTypeResult)
        XCTAssertNil(stringTypeResult)
    }

    func testParseForItemList_WithIntArrayJSON_ShouldReturnItemList() {
        // Arrange
        let json = [1,2,3,4,5]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: [Int].self, from: json)
        
        // Assert
        XCTAssertEqual(result, json)
    }
    
    func testParseForItemList_WithDictJSON_ShouldReturnNil() {
        // Arrange
        let json = ["hello":"goodbye"]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: [Int].self, from: json)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testParseForItem_WithDictJSONWithCorrectKeys_ShouldReturnItem() {
        // Arrange
        let json: [String:Any] = ["id":1,"title":"thisisatitle","by":"author","score":1,"type":"story","kids":[1,2,3]]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: Item.self, from: json)
        let item = Item(id: 1, title: "thisisatitle", user: "author", score: 1, description: "story", commentList: [1,2,3], comments: [])
        
        // Assert
        XCTAssertEqual(result?.title,item.title)
        XCTAssertEqual(result?.id,item.id)
        XCTAssertEqual(result?.user,item.user)
        XCTAssertEqual(result?.score,item.score)
        XCTAssertEqual(result?.description,item.description)
        XCTAssertEqual(result?.commentList,item.commentList)
        XCTAssertTrue(result!.comments.isEmpty)
    }
    
    func testParseForItem_WithDictJSONWithIncorrectKeys_ShouldReturnNil() {
        // Arrange
        let json = ["hello":"goodbye"]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: Item.self, from: json)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testParseForComment_WithDictJSONWithCorrectKeys_ShouldReturnComment() {
        // Arrange
        let json: [String:Any] = ["id":1,"parent":1,"text":"thisisacomment"]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: Comment.self, from: json)
        let comment = Comment(id: 1, parent: 1, text: "thisisacomment", level: 0)
        
        // Assert
        XCTAssertEqual(result?.parent,comment.parent)
        XCTAssertEqual(result?.id,comment.id)
        XCTAssertEqual(result?.text,comment.text)
        XCTAssertEqual(result?.level,comment.level)
    }
    
    func testParseForComment_WithDictJSONWithIncorrectKeys_ShouldReturnNil() {
        // Arrange
        let json: [String:Any] = ["hello":"goodbye"]
        let jsonParser = JSONParser()
        
        // Act
        let result = jsonParser.parse(type: Comment.self, from: json)
        
        // Assert
        XCTAssertNil(result)
    }
}
