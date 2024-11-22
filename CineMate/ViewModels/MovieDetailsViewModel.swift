//
//  MovieDetailsViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation

// Protocol for Content details
protocol ContentDataProvider {
    var title: String { get }
    var releaseDate: String { get }
    var genres: String { get }
    var plot: String { get }
    var cast: String { get }
    var directors: String { get }
    var posterURL: String { get }
}

// Protocol for Ratings
protocol RatingProvider {
    func getRatingDetails() -> [RatingDetails]
}

// Combined Protocol for View Model
protocol  ContentDetailViewModelProtocol: ContentDataProvider, RatingProvider {}

class ContentDetailViewModel: ContentDetailViewModelProtocol {
    var title: String { content.title }
    var releaseDate: String { content.released }
    var genres: String { content.genre }
    var plot: String { content.plot }
    var cast: String { content.actors }
    var directors: String { content.director }
    var posterURL: String { content.poster }
    
    
    private var ratingsDetailsProvider: RatingDetailsProvider
   
    private let content: ContentProvider
    
    init(content: ContentProvider, ratingsDetailsProvider: RatingDetailsProvider = DefaultRatingDetailsProvider()) {
        self.content = content
        self.ratingsDetailsProvider = ratingsDetailsProvider
    }

    func getRatingDetails() -> [RatingDetails] {
        return content.ratings.map(ratingsDetailsProvider.convertToDetails)
    }
}
