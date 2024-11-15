//
//  SearchViewModelTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 14/11/24.
//

import XCTest
@testable import CineMate

class SearchMoviesViewModelTests: XCTestCase {
    var sut: SearchMoviesViewModel!
    
    override func setUp() {
        super.setUp()
        sut = SearchMoviesViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func test_load_movies() {
        sut.loadMovies()
        
        XCTAssertNotNil(sut.movies)
        XCTAssertEqual(sut.movies?.count, 19)
        XCTAssertNotNil(sut.categories)
        XCTAssertEqual(sut.categories.count, 5)
        XCTAssertEqual(sut.rows.count, 5)
    }
    
    func test_sort_ascending_filter() {
        sut.loadMovies()
        
        sut.sort(filter: .ascending)
        
        XCTAssertEqual(sut.currentSortOrder, Filters.ascending)
        for category in sut.categories {
            for subCategory in category.subCategories {
                XCTAssertTrue(isSorted(subCategory.movies, by: .ascending))
            }
        }
        
        XCTAssertTrue(isSorted(sut.movies ?? [], by: .ascending))
    }
    
    func test_sort_descending_filter() {
        sut.loadMovies()
        
        sut.sort(filter: .descending)
        
        XCTAssertEqual(sut.currentSortOrder, Filters.descending)
        for category in sut.categories {
            for subCategory in category.subCategories {
                XCTAssertTrue(isSorted(subCategory.movies, by: .descending))
            }
        }
        
        XCTAssertTrue(isSorted(sut.movies ?? [], by: .descending))
    }
    
    func test_number_of_sections() {
        sut.loadMovies()
        sut.isSearchActive = false
        let sections = sut.numberOfSections()
        XCTAssertEqual(sections, 5)
    }
    
    func test_number_of_sections_when_search_is_active() {
        sut.loadMovies()
        sut.isSearchActive = true
        let sections = sut.numberOfSections()
        XCTAssertEqual(sections, 1)
    }
    
    func test_UpdateSearchResults_With_Query_FiltersCorrectly() {
        sut.loadMovies()
        
        sut.updateSearchResults(with: "america")
        
        XCTAssertTrue(sut.isSearchActive)
        XCTAssertFalse(sut.searchResults.isEmpty)
        for movie in sut.searchResults {
            XCTAssertTrue(movie.title.lowercased().contains("america") ||
                          movie.actorCollection.contains { $0.lowercased().contains("america") } ||
                          movie.directorCollection.contains { $0.lowercased().contains("america") } ||
                          movie.genreCollection.contains { $0.lowercased().contains("america") })
        }
    }
    
    func test_UpdateSearchResults_WithEmptyQuery_ClearsResults() {
        sut.loadMovies()
        
        sut.updateSearchResults(with: "")
        XCTAssertFalse(sut.isSearchActive)
        XCTAssertTrue(sut.searchResults.isEmpty)
    }
    
    func test_ToggleCategory_UpdatesExpansionState() {
        let mockDelegate = MockSearchViewModelDelegate()
        var called = false
        mockDelegate.toggleSectionExpansionHandler = { _ in 
            called = true
        }
        sut.delegate = mockDelegate
        
        sut.loadMovies()
        
    
        sut.toggleCategory(indexPath: IndexPath(row: 0, section: 0))

        XCTAssertTrue(sut.categories[0].isExpanded)
        XCTAssertTrue(called)
    }
    
    func test_ToggleSubCategory_UpdatesExpansionState() {
        sut.loadMovies()
    
        sut.toggleCategory(indexPath: IndexPath(row: 1, section: 0))

        XCTAssertTrue(sut.categories[0].subCategories[0].isExpanded)
    }
    
    func test_get_rowType() {
        sut.loadMovies()
        sut.isSearchActive = false
        let rowType = sut.getRowType(for: IndexPath(row: 0, section: 0))
        
        switch rowType {
        case .category:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func test_get_rowType_when_search_is_active() {
        sut.loadMovies()
        sut.updateSearchResults(with: "america")
        
        let rowType = sut.getRowType(for: IndexPath(row: 0, section: 0))
        
        switch rowType {
        case .movie:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
}

extension SearchMoviesViewModelTests {
    func isSorted<T: Comparable>(_ array: [T], by order: Filters) -> Bool {
            if order == .ascending {
                return array == array.sorted()
            } else {
                return array == array.sorted(by: >)
            }
        }
}

extension Movie: Comparable {
    public static func < (lhs: CineMate.Movie, rhs: CineMate.Movie) -> Bool {
        lhs.title < rhs.title
    }
    
    public static func == (lhs: CineMate.Movie, rhs: CineMate.Movie) -> Bool {
        lhs.title == rhs.title
    }
}


class MockSearchViewModelDelegate: SearchViewModelDelegate {
    var toggleSectionExpansionHandler: ((Int) -> Void)?
    
    func toggleSectionExpansion(at index: Int) {
        toggleSectionExpansionHandler?(index)
    }
}
