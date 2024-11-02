//
//  MovieDetailsViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation
import UIKit
class MovieDetailsViewModel {
    var title: String { movie.title }
    var releaseDate: String { movie.released }
    var genres: String { movie.genre }
    var plot: String { movie.plot }
    var cast: String { movie.actors }
    var directors: String { movie.director }
    var posterURL: String { movie.poster }
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    private func convertRatingToPercentage(ratingString: String) -> Double {
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
        return 0.0
    }
    
    func getRatingDetails() -> [RatingDetails] {
        return movie.ratings.map { rating in
            RatingDetails(title: rating.source, percentage: convertRatingToPercentage(ratingString: rating.value) )
        }
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.downloadImage(from: posterURL) { image in
            DispatchQueue.main.async {
                completion(image ?? .placeholder)
            }
        }
    }
}
