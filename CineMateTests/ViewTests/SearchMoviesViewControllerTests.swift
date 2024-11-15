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
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.viewModel)
    }
    
    func test_ViewDidLoad_Configures_ViewModel() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.viewModel)
        XCTAssertNotNil(sut.viewModel.delegate)
    }
    
    func test_Configure_View_Controller() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertEqual(sut.view?.backgroundColor, UIColor.systemBackground)
        XCTAssertEqual(sut.title, Constants.searchControllerTitle)
    }
    
    func test_Configure_TableView() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertEqual(sut.tableView.backgroundColor, .systemBackground)
    }
    
    func test_Configure_SegmentControl() {
        // Given
        sut.loadViewIfNeeded()
        let segmentControl = sut.segmentControl
        
        // Then
        XCTAssertNotNil(segmentControl)
        XCTAssertEqual(segmentControl.numberOfSegments, 2)
        XCTAssertEqual(segmentControl.selectedSegmentIndex, 0)
    }
    
    func test_Configure_Search_Controller() {
        // Given
        sut.loadViewIfNeeded()
        
        // Then
        let searchController = sut.navigationItem.searchController
        XCTAssertNotNil(searchController)
        XCTAssertEqual(searchController?.searchBar.placeholder, Constants.searchBarPlaceHolder)
    }
    
    // MARK: - Search Tests
    
    func test_SearchController_UpdatesResults() {
        // Given
        var searchQuery: String?
        mockViewModel.updateSearchResultsHandler = { query in
            searchQuery = query
        }
        
        // When
        let searchController = UISearchController()
        searchController.searchBar.text = "Test Query"
        sut.updateSearchResults(for: searchController)
        
        // Then
        XCTAssertEqual(searchQuery, "Test Query")
    }
    
    // MARK: - Segment Control Tests
    
    func test_SegmentControl_SortsAscending() {
        // Given
        var sortFilter: Filters?
        
        // When
        mockViewModel.sortHandler = { filter in
            sortFilter = filter
        }
        
        let segmentControl = sut.segmentControl
        segmentControl.selectedSegmentIndex = 0
        sut.segmentControlClicked(segmentControl)
        
        // Then
        XCTAssertEqual(sortFilter, .ascending)
    }
    
    func test_SegmentControl_SortsDescending() {
        // Given
        var sortFilter: Filters?
        
        // When
        mockViewModel.sortHandler = { filter in
            sortFilter = filter
        }
        
        let segmentControl = sut.segmentControl
        segmentControl.selectedSegmentIndex = 1
        sut.segmentControlClicked(segmentControl)
        
        // Then
        XCTAssertEqual(sortFilter, .descending)
    }
    
    
    // MARK: - TableView DataSource Tests
    
    func test_NumberOfSections_CallsViewModel() {
        // Given
        var called = false
        mockViewModel.numberOfSectionsHandler = {
            called = true
            return 1
        }
        
        // Then
        let result = sut.numberOfSections(in: sut.tableView)
        XCTAssertTrue(called)
        XCTAssertEqual(1, result)
    }
    
    func test_NumberOfRows_CallsViewModel() {
        // Given
        var called = false
        mockViewModel.numberOfRowsHandler = { section in
            called = true
            return 1
        }
        
        // Then
        let result  = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertTrue(called)
        XCTAssertEqual(1, result)
    }
    
    func test_Cell_For_RowAt_For_Category_Cell() {
        // Given
        mockViewModel.rowType = .category(title: "Hello America", isExpanded: false)
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssert(cell is OptionCell)
    }
    
    func test_Cell_For_RowAt_For_SubCategory_Cell() {
        // Given
        mockViewModel.rowType = .subcategory(subcategory: SubCategories(title: "Year", isExpanded: true, movies: [MoviesModelTests.createMockMovie()]))
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        // Then
        XCTAssert(cell is OptionCell)
    }
    
    func test_Cell_For_RowAt_For_Movie_Cell() {
        // Given
        mockViewModel.rowType = .movie(movie: MoviesModelTests.createMockMovie())
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        
        // Then
        XCTAssert(cell is MovieDescriptionCell)
    }
    
    func test_Option_Cell_selected() {
        // Given
        mockViewModel.rowType = .category(title: "Hello America", isExpanded: false)
        var called = false
        mockViewModel.toggleCategoryHandler = { _ in
            called = true
        }
        
        // When
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertTrue(called)
    }
    
    func test_Movie_Cell_selected() {
        // Given
        mockViewModel.rowType = .movie(movie: MoviesModelTests.createMockMovie())
        var called = false
        mockViewModel.toggleCategoryHandler = { _ in
            called = true
        }
        
        // When
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertFalse(called)
    }
}
// MARK: - MockSearchViewModel

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
