//
//  MovieDetailsViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var title: String { get }
    var releaseDate: String { get }
    var genres: String { get }
    var plot: String { get }
    var cast: String { get }
    var directors: String { get }
    var posterURL: String { get }
    
    func getRatingDetails() -> [RatingDetails]
}

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    var title: String { movie.title }
    var releaseDate: String { movie.released }
    var genres: String { movie.genre }
    var plot: String { movie.plot }
    var cast: String { movie.actors }
    var directors: String { movie.director }
    var posterURL: String { movie.poster }
    
    var ratingConvertor = RatingConverter()
   
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }

    func getRatingDetails() -> [RatingDetails] {
        return movie.ratings.map { rating in
            RatingDetails(title: rating.source, percentage: RatingConverter.convertRatingToPercentage(ratingString: rating.value) )
        }
    }
//    
//    func loadImage(completion: @escaping (UIImage?) -> Void) {
//        self.downloadImage(posterURL) { image in
//            completion(image ?? .placeholder)
//        }
//    }
}
