//
//  MovieCategoriesTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 14/11/24.
//

import XCTest
@testable import CineMate

final class MovieCategoriesTests: XCTestCase {
    
    func test_movie_categories_allCases_count() {
        // Given
        let movieCategories = MovieCategories.allCases
        // Then
        XCTAssertEqual(movieCategories.count, 5)
    }
    
    func test_movie_categories_title_for_rawValues() {
        checkMovieCategoryTitle(for: 0, expectedTitle: Constants.year)
        checkMovieCategoryTitle(for: 1, expectedTitle: Constants.genre)
        checkMovieCategoryTitle(for: 2, expectedTitle: Constants.director)
        checkMovieCategoryTitle(for: 3, expectedTitle: Constants.actor)
        checkMovieCategoryTitle(for: 4, expectedTitle: Constants.allMovies)
    }
    
    private func checkMovieCategoryTitle(for rawValue: Int, expectedTitle: String) {
        // Given
        let movieCategory = MovieCategories(rawValue: rawValue)
        // Then
        XCTAssertEqual(movieCategory?.title, expectedTitle)
    }
}
