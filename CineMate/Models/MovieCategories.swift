//
//  MovieCategories.swift
//  CineMate
//
//  Created by Ritika Gupta on 29/10/24.
//

import Foundation

enum MovieCategories: Int, CaseIterable {
    case year
    case genre
    case director
    case actor
    case all
    
    var title: String {
        switch self {
        case .year:
            return Constants.year
        case .genre:
            return Constants.genre
        case .actor:
            return Constants.actor
        case .director:
            return Constants.director
        case .all:
            return Constants.allMovies
        }
    }
}
