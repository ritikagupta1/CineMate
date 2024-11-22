//
//  RatingConvertor.swift
//  CineMate
//
//  Created by Ritika Gupta on 15/11/24.
//

import Foundation
protocol RatingConverter {
    /// Converts a rating string to a percentage value
    /// Returns 0.0 if conversion fails
    func convertRatingToPercentage(ratingString: String) -> Double
}

struct DefaultRatingConverter: RatingConverter {
    // default implementation
    func convertRatingToPercentage(ratingString: String) -> Double {
        if ratingString.contains("/") {
            let components = ratingString.components(separatedBy: "/")
            if let rating = Double(components[0]),
               let total = Double(components[1]) {
                return (rating / total) * 100
            }
        } else if ratingString.hasSuffix("%") {
            let numberString = ratingString.dropLast()
            if let percentage = Double(numberString) {
                return percentage
            }
        }
        
        // Return 0.0 for invalid cases
        return 0.0
    }
}
