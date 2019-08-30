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
        waitForExpectations(timeout: 3)
    }

}
