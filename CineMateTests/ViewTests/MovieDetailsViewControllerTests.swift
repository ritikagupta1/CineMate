//
//  MovieSearchViewControllerTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var mockViewModel: MockMovieDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        // Create mock movie data
        mockViewModel = MockMovieDetailsViewModel()
        sut = MovieDetailViewController(viewModel: mockViewModel)
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func test_VC_Init_Returns_Success() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.viewModel)
    }
    
    func test_set_up_view_controller() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(sut.view.backgroundColor, UIColor.systemBackground)
        XCTAssertNotNil(sut.view.subviews.first as? UIScrollView, "ScrollView should be added to view hierarchy")
        
        let scrollView = sut.view.subviews.first as? UIScrollView
        XCTAssertNotNil(scrollView?.subviews.first, "ContentView should be added to ScrollView")
    }
    
    func test_configure_UI() {
        // Given
        var expectedURL: String = ""
        sut.downloadImage = { posterURL, completion in
            expectedURL = posterURL
            completion(.placeholder)
        }
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(sut.titleLabel.text, mockViewModel.title)
        XCTAssertEqual(sut.releaseDateLabel.text, mockViewModel.releaseDate)
        XCTAssertEqual(sut.genresLabel.text, mockViewModel.genres)
        XCTAssertEqual(sut.plotLabel.text, mockViewModel.plot)
        XCTAssertEqual(sut.castLabel.text, mockViewModel.cast)
        XCTAssertEqual(sut.directorsLabel.text, mockViewModel.directors)
        XCTAssertEqual(sut.castLabel.text, mockViewModel.cast)
        XCTAssertEqual(expectedURL, mockViewModel.posterURL)
        XCTAssertEqual(sut.posterImageView.image, .placeholder)
    }
    
    func test_ratings_setup() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(sut.ratingStack.arrangedSubviews.count, 2)
        let numberOfRatings = mockViewModel.getRatingDetails().count
        let expectedHstacksCount = Int(ceil(Double(numberOfRatings) / 3.0))
        XCTAssertEqual(sut.ratingVStack.arrangedSubviews.count, expectedHstacksCount)
    }
}

// MARK: MockMovieDetailsViewModel

class MockMovieDetailsViewModel: ContentDetailViewModelProtocol {
    var title: String {
        return "Hello Mister"
    }
    
    var releaseDate: String {
        return "07 Oct, 2024"
    }
    
    var genres: String {
        return "Comedy, action"
    }
    
    var plot: String {
        return "Test Plot"
    }
    
    var cast: String {
        return "cast1, cast2"
    }
    
    var directors: String {
        return "testdirector1, testdirector2"
    }
    
    var posterURL: String {
        return "https:\\testURL"
    }
    
    func getRatingDetails() -> [CineMate.RatingDetails] {
        [RatingDetails(title: "IMDB", percentage: 80.0),
         RatingDetails(title: "Rotten Tomatoes", percentage: 70.0),
         RatingDetails(title: "Rotten Tomatoes", percentage: 70.0),
         RatingDetails(title: "Rotten Tomatoes", percentage: 70.0),
         RatingDetails(title: "Rotten Tomatoes", percentage: 70.0)
        ]
    }
}
