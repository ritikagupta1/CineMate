//
//  MovieDescriptionCellViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 15/11/24.
//

import Foundation

class MovieDescriptionCellViewModel {
    var movie: Movie
    var networkManager: NetworkManagerProtocol
    
    init(movie: Movie, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.movie = movie
        self.networkManager = networkManager
    }
    
    var title: String {
        movie.title
    }
    
    var year: String {
        "Year: \(movie.year)"
    }
    
    var languages: String {
        "Language: \(movie.language)"
    }
    
    var poster: String {
        movie.poster
    }
}
