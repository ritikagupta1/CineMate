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
            return "Year"
        case .genre:
            return "Genre"
        case .actor:
            return "Actor"
        case .director:
            return "Director"
        case .all:
            return "All Movies"
        }
    }
}
