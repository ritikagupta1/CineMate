//
//  MovieDescriptionCellViewModelTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class MovieDescriptionCellViewModelTests: XCTestCase {
    
    var sut: MovieDescriptionCellViewModel!
    
    override func setUp() {
        sut = MovieDescriptionCellViewModel(movie: MoviesModelTests.createMockMovie())
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_movie_description_cell_view_model_init() {
        XCTAssertEqual(sut.title, "Meet the Parents")
        XCTAssertEqual(sut.year, "Year: 2000")
        XCTAssertEqual(sut.languages, "Language: English, Thai, Spanish, Hebrew, French")
    }
    
    func test_image_download() {
        let expectedImage: UIImage = .placeholder
        var called = false
        sut.downloadImage = { (urlString, completion) in
            called = true
            completion(expectedImage)
        }
        sut.downloadImage("abc") { image in
            XCTAssertTrue(called)
            XCTAssertEqual(image, expectedImage)
        }
    }
}
