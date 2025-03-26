//
//  CVS_flickrTests.swift
//  CVS_flickrTests
//
//  Created by Tim McEwan on 3/26/25.
//

import XCTest
@testable import CVS_flickr

final class CVS_flickrTests: XCTestCase {
    
   
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFromAEmptyAttributedString() throws {
        
        // Arrange
        let input = ""
        let sut = FlickrDetailView()
        
        // Act
        let attributedString = sut.attributedString(from: input)
        
        // Assert
        XCTAssertNotNil(input)
        XCTAssertEqual(attributedString, "")
    }

}
