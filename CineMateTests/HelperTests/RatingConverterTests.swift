//
//  RatingConverterTests.swift
//  CineMateTests
//
//  Created by Ritika Gupta on 15/11/24.
//

import XCTest
@testable import CineMate

final class RatingConverterTests: XCTestCase {
    func test_convertRatingToPercentage_withFractionFormat() {
        XCTAssertEqual(RatingConverter.convertRatingToPercentage(ratingString: "8/10"), 80.0)
        XCTAssertEqual(RatingConverter.convertRatingToPercentage(ratingString: "3/5"), 60.0)
    }
    
    func test_convertRatingToPercentage_withPercentageFormat() {
        XCTAssertEqual(RatingConverter.convertRatingToPercentage(ratingString: "75%"), 75.0)
    }
    
    func test_convertRatingToPercentage_withInvalidFormat() {
        XCTAssertEqual(RatingConverter.convertRatingToPercentage(ratingString: "invalid"), 0.0)
    }
}
