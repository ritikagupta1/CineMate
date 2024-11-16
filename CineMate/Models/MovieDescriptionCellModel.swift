//
//  MovieDescriptionCellViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 15/11/24.
//

import Foundation

class MovieDescriptionCellModel {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
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
