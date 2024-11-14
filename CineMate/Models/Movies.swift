//
//  Movies.swift
//  MovieDB
//
//  Created by Ritika Gupta on 26/10/24.
//

import Foundation
struct Movie: Codable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let poster: String
    let ratings: [Rating]
    
    var genreCollection: [String] {
        genre.components(separatedBy: ",")
    }
    
    var directorCollection: [String] {
        director.components(separatedBy: ",")
    }
    
    var actorCollection: [String] {
        actors.components(separatedBy: ",")
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case poster = "Poster"
        case ratings = "Ratings"
    }
}

struct Rating: Codable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
