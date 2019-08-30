//
//  ItemDetailViewControllerTests.swift
//  HackerNewsTests
//
//  Created by Alexander Ge on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

@testable import HackerNews
import XCTest

class ItemDetailViewControllerTests: XCTestCase {

//    var detailVC: ItemDetailViewController!
    
    func testLoadFromStoryboard_ShouldCreateVC() {
        XCTAssertNotNil(UIStoryboard(name: "ItemList", bundle: .main).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController)
    }
    
    func testSetItemBeforeViewLoaded_ShouldSetUIWhenViewLoaded() {
        // Arrange
        let detailVC = UIStoryboard(name: "ItemList", bundle: .main).instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        
        // Act
        detailVC.item = Item(id: 1, title: "Hello", user: "Boogie", score: 19, description: "story", commentList: [], comments: [])
        let _ = detailVC.view
        
        // Assert
        XCTAssertEqual(detailVC.exposedTitleLabel.text, "Hello")
        XCTAssertEqual(detailVC.exposedDescriptionLabel.text, "story")
        XCTAssertEqual(detailVC.exposedScoreLabel.text, "19")
        XCTAssertEqual(detailVC.exposedAuthorLabel.text, "Boogie")
    }
    
    func testSetItemAfterViewLoaded_ShouldSetUIWhenViewLoaded() {
        // Arrange
        let detailVC = UIStoryboard(name: "ItemList", bundle: .main).instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        
        // Act
        let _ = detailVC.view
        detailVC.item = Item(id: 1, title: "Hello", user: "Boogie", score: 19, description: "story", commentList: [], comments: [Comment(id: 1, parent: 1, text: "comment")])
        
        // Assert
        DispatchQueue.main.async {
            XCTAssertEqual(detailVC.exposedTitleLabel.text, "Hello")
            XCTAssertEqual(detailVC.exposedDescriptionLabel.text, "story")
            XCTAssertEqual(detailVC.exposedScoreLabel.text, "19")
            XCTAssertEqual(detailVC.exposedAuthorLabel.text, "Boogie")
            XCTAssertEqual(detailVC.exposedComment1Label.text, "comment")
        }
    }
}
