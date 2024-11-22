//
//  RatingDetails.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation
protocol RatingDetailsProvider {
    func convertToDetails(_ rating: Rating) -> RatingDetails
}

struct DefaultRatingDetailsProvider: RatingDetailsProvider {
    private let ratingConverter: RatingConverter
    
    init(ratingConverter: RatingConverter = DefaultRatingConverter()) {
        self.ratingConverter = ratingConverter
    }
    
    func convertToDetails(_ rating: Rating) -> RatingDetails {
        RatingDetails(
            title: rating.source,
            percentage: ratingConverter.convertRatingToPercentage(ratingString: rating.value)
        )
    }
}
