//
//  RatingConverterTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class RatingConverterTests: XCTestCase {
    var sut: RatingConverter!
    
    override func setUp() {
        super.setUp()
        sut = DefaultRatingConverter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func test_convertRatingToPercentage_withFractionFormat() {
        XCTAssertEqual(sut.convertRatingToPercentage(ratingString: "8/10"), 80.0)
        XCTAssertEqual(sut.convertRatingToPercentage(ratingString: "3/5"), 60.0)
    }
    
    func test_convertRatingToPercentage_withPercentageFormat() {
        XCTAssertEqual(sut.convertRatingToPercentage(ratingString: "75%"), 75.0)
    }
    
    func test_convertRatingToPercentage_withInvalidFormat() {
        XCTAssertEqual(sut.convertRatingToPercentage(ratingString: "invalid"), 0.0)
    }
}
