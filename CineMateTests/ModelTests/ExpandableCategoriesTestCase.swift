//
//  ExpandableCategoriesTestCase.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 14/11/24.
//

import XCTest
@testable import CineMate

final class ExpandableCategoriesTestCase: XCTestCase {
    
    func test_expandableCategories_initialization() {
        // Given
        let subCategories = [
            SubCategories(title: "Action", isExpanded: false, movies: [MoviesModelTests.createMockMovie()]),
            SubCategories(title: "Drama", isExpanded: true, movies: [MoviesModelTests.createMockMovie()])
        ]
        
        let expandableCategory = ExpandableCategories(title: "Genres", isExpanded: false, subCategories: subCategories)
        
        // Then
        XCTAssertEqual(expandableCategory.title, "Genres")
        XCTAssertFalse(expandableCategory.isExpanded)
        XCTAssertEqual(expandableCategory.subCategories.count, 2)
    }
    
    func test_subCategories_initialization() {
        // Given
        let movies = [MoviesModelTests.createMockMovie(), MoviesModelTests.createMockMovie()]
        let subCategory = SubCategories(title: "Action", isExpanded: true, movies: movies)
        
        // Then
        XCTAssertEqual(subCategory.title, "Action")
        XCTAssertTrue(subCategory.isExpanded)
        XCTAssertEqual(subCategory.movies.count, 2)
    }
    
    func test_expandableCategories_isExpanded_toggle() {
        // Given
        let expandableCategory = ExpandableCategories(title: "Genres", isExpanded: false, subCategories: [])
        // When
        expandableCategory.isExpanded.toggle()
        // Then
        XCTAssertTrue(expandableCategory.isExpanded)
        // When
        expandableCategory.isExpanded.toggle()
        // Then
        XCTAssertFalse(expandableCategory.isExpanded)
    }
    
    func test_subCategories_isExpanded_toggle() {
        // Given
        let subCategory = SubCategories(title: "Action", isExpanded: false, movies: [])
        // When
        subCategory.isExpanded.toggle()
        // Then
        XCTAssertTrue(subCategory.isExpanded)
        // When
        subCategory.isExpanded.toggle()
        // Then
        XCTAssertFalse(subCategory.isExpanded)
    }
    
    func test_rowType_initialisation() {
        // Given
        let rowType = RowType.category(title: "Hello America", isExpanded: false)
        // Then
        switch rowType {
        case .category(let title, let isExpanded):
            XCTAssertEqual(title, "Hello America")
            XCTAssertFalse(isExpanded)
        default:
            XCTFail()
        }
    }
}
