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
        let subCategories = [
            SubCategories(title: "Action", isExpanded: false, movies: [MoviesModelTests.createMockMovie()]),
            SubCategories(title: "Drama", isExpanded: true, movies: [MoviesModelTests.createMockMovie()])
        ]
        
        let expandableCategory = ExpandableCategories(title: "Genres", isExpanded: false, subCategories: subCategories)
        
        XCTAssertEqual(expandableCategory.title, "Genres")
        XCTAssertFalse(expandableCategory.isExpanded)
        XCTAssertEqual(expandableCategory.subCategories.count, 2)
    }
    
    func test_subCategories_initialization() {
        let movies = [MoviesModelTests.createMockMovie(), MoviesModelTests.createMockMovie()]
        let subCategory = SubCategories(title: "Action", isExpanded: true, movies: movies)
        
        XCTAssertEqual(subCategory.title, "Action")
        XCTAssertTrue(subCategory.isExpanded)
        XCTAssertEqual(subCategory.movies.count, 2)
    }
    
    func test_expandableCategories_isExpanded_toggle() {
        let expandableCategory = ExpandableCategories(title: "Genres", isExpanded: false, subCategories: [])
        expandableCategory.isExpanded.toggle()
        
        XCTAssertTrue(expandableCategory.isExpanded)
        
        expandableCategory.isExpanded.toggle()
        
        XCTAssertFalse(expandableCategory.isExpanded)
    }
    
    func test_subCategories_isExpanded_toggle() {
        let subCategory = SubCategories(title: "Action", isExpanded: false, movies: [])
        subCategory.isExpanded.toggle()
        
        XCTAssertTrue(subCategory.isExpanded)
        
        subCategory.isExpanded.toggle()
        
        XCTAssertFalse(subCategory.isExpanded)
    }
    
    func test_rowType_initialisation() {
        let rowType = RowType.category(title: "Hello America", isExpanded: false)
        switch rowType {
        case .category(let title, let isExpanded):
            XCTAssertEqual(title, "Hello America")
            XCTAssertFalse(isExpanded)
        default:
            XCTFail()
        }
    }
}
