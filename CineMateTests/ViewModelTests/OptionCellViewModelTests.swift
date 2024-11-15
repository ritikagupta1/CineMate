//
//  OptionCellViewModelTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class OptionCellViewModelTests: XCTestCase {
    func test_option_cell_init() {
        let viewModel = OptionCellViewModel(title: "Test Title", indentationLevel: 1, isExpanded: true)
        
        XCTAssertEqual(viewModel.title, "Test Title")
        XCTAssertEqual(viewModel.indentationLevel, 1)
        XCTAssertTrue(viewModel.isExpanded)
    }
}