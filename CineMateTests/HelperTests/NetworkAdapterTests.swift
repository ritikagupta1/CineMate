//
//  NetworkAdapterTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class NetworkAdapterTests: XCTestCase {
    
    func test_download_image_with_valid_request_returns_image() {
        // Given
        
        let url = "https://m.media-amazon.com/images/M/MV5BMGNlMGZiMmUtZjU0NC00MWU4LWI0YTgtYzdlNGVhZGU4NWZlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg"
        
        let expectation = expectation(description: "valid request returns image")
        NetworkAdapter.downloadImage(from: url) { image in
            expectation.fulfill()
            XCTAssertNotNil(image)
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func test_download_image_with_Invalid_request_returns_nil() {
        // Given
        
        let url = "https://invalidabc.jpg"
        
        let expectation = expectation(description: "invalid request returns nil")
        NetworkAdapter.downloadImage(from: url) { image in
            
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_download_image_with_Invalid_url_returns_nil() {
        // Given
        
        let url = "https://ansdd"
        
        let expectation = expectation(description: "invalid url returns nil")
        NetworkAdapter.downloadImage(from: url) { image in
            
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
