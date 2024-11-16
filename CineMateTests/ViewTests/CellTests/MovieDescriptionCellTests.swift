//
//  MovieDescriptionCellTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 16/11/24.
//

import XCTest
@testable import CineMate

final class MovieDescriptionCellTests: XCTestCase {
    var sut: MovieDescriptionCell!
    
    override func setUp() {
        sut = MovieDescriptionCell()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_movie_description_cell_init() {
        XCTAssertEqual(sut.indentationLevel, 2)
        XCTAssertEqual(sut.backgroundColor, UIColor.clear)
        XCTAssertNil(sut.accessoryView)
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.yearLabel)
        XCTAssertNotNil(sut.languageLabel)
        XCTAssertNotNil(sut.detailsStack)
        XCTAssertNotNil(sut.posterImageView)
    }
    
    
    func test_movie_description_cell_configuration() {
        let viewModel = MovieDescriptionCellModel(movie: MoviesModelTests.createMockMovie())
        
        sut.downloadImage = { urlString, completion in
            completion(.placeholder)
        }
        
        sut.configure(viewModel: viewModel)
        
        XCTAssertEqual(sut.titleLabel.text, viewModel.title)
        XCTAssertEqual(sut.yearLabel.text, viewModel.year)
        XCTAssertEqual(sut.languageLabel.text, viewModel.languages)
        
        XCTAssertEqual(sut.posterImageView.image, .placeholder)
    }
    
    func test_prepare_for_reuse() {
        sut.prepareForReuse()
        XCTAssertNil(sut.titleLabel.text)
        XCTAssertNil(sut.languageLabel.text)
        XCTAssertNil(sut.yearLabel.text)
        XCTAssertNil(sut.posterImageView.image)
    }
}
