//
//  MovieDetailsViewModelTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class MovieDetailsViewModelTests: XCTestCase {
    var sut: ContentDetailViewModel!
    
    override func setUp() {
        super.setUp()
        sut = ContentDetailViewModel(
            content: MoviesModelTests.createMockMovie() 
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_movie_detail_view_model_init() {
        XCTAssertEqual(sut.title, "Meet the Parents")
        XCTAssertEqual(sut.releaseDate, "06 Oct 2000")
        XCTAssertEqual(sut.genres, "Comedy, Romance, Action")
        XCTAssertEqual(sut.plot, "A Jewish male nurse plans")
        XCTAssertEqual(sut.cast, "Robert De Niro, Ben Stiller, Teri Polo, Blythe Danner")
        XCTAssertEqual(sut.directors, "Jay Roach")
        XCTAssertEqual(sut.posterURL, "https://m.media-amazon.com/images")
    }
    
    func test_getRatingDetails_returnsCorrectConvertedRatings() {
        let ratings = sut.getRatingDetails()
        
        XCTAssertEqual(ratings.count, 3)
        XCTAssertEqual(ratings[0].title, "Internet Movie Database")
        XCTAssertEqual(ratings[0].percentage, 70.0)
        XCTAssertEqual(ratings[1].title, "Rotten Tomatoes")
        XCTAssertEqual(ratings[1].percentage, 84.0)
        XCTAssertEqual(ratings[2].title, "Metacritic")
        XCTAssertEqual(ratings[2].percentage, 73.0)
    }
}
