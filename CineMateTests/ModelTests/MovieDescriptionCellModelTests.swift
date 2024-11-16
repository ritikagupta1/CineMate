//
//  MovieDescriptionCellViewModelTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class MovieDescriptionCellModelTests: XCTestCase {
    var sut: MovieDescriptionCellModel!
    
    override func setUp() {
        sut = MovieDescriptionCellModel(movie: MoviesModelTests.createMockMovie())
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
}
