//
//  OptionCellTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 16/11/24.
//

import XCTest
@testable import CineMate

final class OptionCellTests: XCTestCase {
    var sut: OptionCell!
    
    override func setUp() {
        super.setUp()
        sut = OptionCell(style: .default, reuseIdentifier: OptionCell.identifier)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_option_cell_init() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_option_cell_configuration() {
        let viewModel = OptionCellModel(title: "Test Title", indentationLevel: 1, isExpanded: true)
        sut.setup(viewModel: viewModel)
        
        XCTAssertEqual(sut.titleLabel.text, "Test Title")
        XCTAssertEqual(sut.indentationLevel, 1)
        XCTAssertNotNil(sut.accessoryView)
        
        let accessoryImageView = sut.accessoryView as? UIImageView
        XCTAssertNotNil(accessoryImageView)
        XCTAssertEqual(accessoryImageView?.image, UIImage(systemName: "chevron.down"))
    }
}
