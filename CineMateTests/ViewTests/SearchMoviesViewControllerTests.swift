//
//  SearchMoviesViewControllerTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 14/11/24.
//

import XCTest
@testable import CineMate

final class SearchMoviesViewControllerTests: XCTestCase {
    var sut: MovieSearchVC!
    var mockViewModel: MockSearchViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockSearchViewModel()
        sut = MovieSearchVC(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func test_VC_Init_Returns_Success() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut)
    }
    
    func test_ViewDidLoad_Configures_ViewModel() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.viewModel)
        XCTAssertNotNil(sut.viewModel.delegate)
    }
    
    func test_Configure_View_Controller() {
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.view?.backgroundColor, UIColor.systemBackground)
        XCTAssertEqual(sut.title, Constants.searchControllerTitle)
    }
    
    func test_Configure_TableView() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertEqual(sut.tableView.backgroundColor, .systemBackground)
    }
    
    func test_Configure_SegmentControl() {
        sut.loadViewIfNeeded()
        let segmentControl = sut.segmentControl
        
        XCTAssertNotNil(segmentControl)
        XCTAssertEqual(segmentControl.numberOfSegments, 2)
        XCTAssertEqual(segmentControl.selectedSegmentIndex, 0)
    }
    
    func test_Configure_Search_Controller() {
        sut.loadViewIfNeeded()
        let searchController = sut.navigationItem.searchController
        XCTAssertNotNil(searchController)
        XCTAssertEqual(searchController?.searchBar.placeholder, Constants.searchBarPlaceHolder)
    }
    
    // MARK: - Search Tests
    
    func test_SearchController_UpdatesResults() {
        var searchQuery: String?
        mockViewModel.updateSearchResultsHandler = { query in
            searchQuery = query
        }
        
        let searchController = UISearchController()
        searchController.searchBar.text = "Test Query"
        sut.updateSearchResults(for: searchController)
        
        XCTAssertEqual(searchQuery, "Test Query")
    }
    
    // MARK: - Segment Control Tests
    
    func test_SegmentControl_SortsAscending() {
        var sortFilter: Filters?
        mockViewModel.sortHandler = { filter in
            sortFilter = filter
        }
        
        let segmentControl = sut.segmentControl
        segmentControl.selectedSegmentIndex = 0
        sut.segmentControlClicked(segmentControl)
        
        XCTAssertEqual(sortFilter, .ascending)
    }
    
    func test_SegmentControl_SortsDescending() {
        var sortFilter: Filters?
        mockViewModel.sortHandler = { filter in
            sortFilter = filter
        }
        
        let segmentControl = sut.segmentControl
        segmentControl.selectedSegmentIndex = 1
        sut.segmentControlClicked(segmentControl)
        
        XCTAssertEqual(sortFilter, .descending)
    }
    
    
    // MARK: - TableView DataSource Tests
    
    func test_NumberOfSections_CallsViewModel() {
        var called = false
        mockViewModel.numberOfSectionsHandler = {
            called = true
            return 1
        }
        
        let result = sut.numberOfSections(in: sut.tableView)
        XCTAssertTrue(called)
        XCTAssertEqual(1, result)
    }
    
    func test_NumberOfRows_CallsViewModel() {
        var called = false
        mockViewModel.numberOfRowsHandler = { section in
            called = true
            return 1
        }
        
        let result  = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertTrue(called)
        XCTAssertEqual(1, result)
    }
    
    func test_Cell_For_RowAt_For_Category_Cell() {
        mockViewModel.rowType = .category(title: "Hello America", isExpanded: false)
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssert(cell is OptionCell)
    }
    
    func test_Cell_For_RowAt_For_SubCategory_Cell() {
        mockViewModel.rowType = .subcategory(subcategory: SubCategories(title: "Year", isExpanded: true, movies: [MoviesModelTests.createMockMovie()]))
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssert(cell is OptionCell)
    }
    
    func test_Cell_For_RowAt_For_Movie_Cell() {
        mockViewModel.rowType = .movie(movie: MoviesModelTests.createMockMovie())
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        XCTAssert(cell is MovieDescriptionCell)
    }
    
    func test_Option_Cell_selected() {
        mockViewModel.rowType = .category(title: "Hello America", isExpanded: false)
        var called = false
        mockViewModel.toggleCategoryHandler = { _ in
            called = true
        }
        
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(called)
    }
    
    func test_Movie_Cell_selected() {
        mockViewModel.rowType = .movie(movie: MoviesModelTests.createMockMovie())
        var called = false
        mockViewModel.toggleCategoryHandler = { _ in
            called = true
        }
        
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertFalse(called)
    }
}
// MARK: - Mock Implementation

class MockSearchViewModel: SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate?
    
    var loadMoviesHandler: (() -> Void)?
    var numberOfSectionsHandler: (() -> Int)?
    var numberOfRowsHandler: ((Int) -> Int)?
    var toggleCategoryHandler: ((IndexPath) -> Void)?
    var updateSearchResultsHandler: ((String) -> Void)?
    var sortHandler: ((Filters) -> Void)?
    
    var rowType: RowType = .category(title: "Action", isExpanded: true)
    
    
    func loadMovies() {
        loadMoviesHandler?()
    }
    
    func numberOfSections() -> Int {
        return numberOfSectionsHandler?() ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return numberOfRowsHandler?(section) ?? 0
    }
    
    func toggleCategory(indexPath: IndexPath) {
        toggleCategoryHandler?(indexPath)
    }
    
    func updateSearchResults(with query: String) {
        updateSearchResultsHandler?(query)
    }
    
    func sort(filter: Filters) {
        sortHandler?(filter)
    }
    
    func getRowType(for indexPath: IndexPath) -> RowType {
        return rowType
    }
}


class MockSearchViewModelDelegate: SearchViewModelDelegate {
    var toggleSectionExpansionHandler: ((Int) -> Void)?
    
    func toggleSectionExpansion(at index: Int) {
        toggleSectionExpansionHandler?(index)
    }
}
