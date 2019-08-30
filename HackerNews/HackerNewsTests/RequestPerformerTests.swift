//
//  RequestPerformerTests.swift
//  HackerNewsTests
//
//  Created by Alexander Ge on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

@testable import HackerNews
import XCTest

class RequestPerformerTests: XCTestCase {
    
    func testFetchItemList_WithIntArrayData_ShouldCallHandler() {
        // Arrange
        let mockURLSession = MockURLSession(objectToReturnAsData: [1,2,3,4,5])
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let successExpectation = expectation(description: "success response")
        
        // Act
        requestPerformer.fetchTopItemIds { array in
            // Assert
            if array == [1,2,3,4,5] {
                successExpectation.fulfill()
            } else {
                XCTFail("Array does not match")
            }
        }
        waitForExpectations(timeout: 1)
    }

    func testFetchItemList_WithoutIntArrayData_ShouldNotCallHandler() {
        // Arrange
        let mockURLSession = MockURLSession(objectToReturnAsData: ["hello":"goodbye"])
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let failureExpectation = expectation(description: "called handler")
        failureExpectation.isInverted = true
        
        // Act
        requestPerformer.fetchTopItemIds { array in
            // Assert
            failureExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertTrue(true)
        }
    }
    
    func testFetchItemDetail_WithItemDictionaryDataResponse_ShouldCallHandler() {
        // Arrange
        let itemDict: [String:String] = ["id":"1","title":"thisisatitle","by":"author","score":"1","type":"story"]
        let mockURLSession = MockURLSession(objectToReturnAsData: itemDict)
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let successExpectation = expectation(description: "success response")
        
        // Act
        requestPerformer.fetchItemDetail(itemID: "1") { item in
            // Assert
            if item?.id == 1,
                item?.title == "thisisatitle",
                item?.user == "author",
                item?.score == 1,
                item?.description == "story" {
                
                successExpectation.fulfill()
            } else {
                XCTFail("Item does not match")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFetchItemDetail_WithoutItemDictionaryDataResponse_ShouldNotCallHandler() {
        // Arrange
        let itemDict: [String:String] = ["id":"1"]
        let mockURLSession = MockURLSession(objectToReturnAsData: itemDict)
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let failureExpectation = expectation(description: "failure response")
        failureExpectation.isInverted = true
        
        // Act
        requestPerformer.fetchItemDetail(itemID: "1") { item in
            // Assert
            failureExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertTrue(true)
        }
    }
    
    func testFetchComment_WithCommentDictionaryDataResponse_ShouldCallHandler() {
        // Arrange
        let commentDict: [String:String] = ["id":"1","parent":"1","text":"thisisacomment"]
        let mockURLSession = MockURLSession(objectToReturnAsData: commentDict)
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let successExpectation = expectation(description: "success response")
        
        // Act
        requestPerformer.fetchComment(commentID: "1") { comment in
            // Assert
            if comment?.id == 1,
                comment?.text == "thisisacomment",
                comment?.parent == 1 {
                
                successExpectation.fulfill()
            } else {
                XCTFail("Item does not match")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFetchComment_WithoutCommentDictionaryDataResponse_ShouldNotCallHandler() {
        // Arrange
        let commentDict: [String:String] = ["id":"1"]
        let mockURLSession = MockURLSession(objectToReturnAsData: commentDict)
        let requestPerformer = RequestPerformer(urlSession: mockURLSession)
        let failureExpectation = expectation(description: "failure response")
        failureExpectation.isInverted = true
        
        // Act
        requestPerformer.fetchComment(commentID: "1") { comment in
            // Assert
            failureExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertTrue(true)
        }
    }
}
