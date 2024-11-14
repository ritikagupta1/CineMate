//
//  ExpandableCategories.swift
//  CineMate
//
//  Created by Ritika Gupta on 29/10/24.
//

import Foundation
// Used for the datasource of tableView

class ExpandableCategories {
    let title: String
    var isExpanded: Bool
    var subCategories: [SubCategories]
    
    init(title: String, isExpanded: Bool, subCategories: [SubCategories]) {
        self.title = title
        self.isExpanded = isExpanded
        self.subCategories = subCategories
    }
}

class SubCategories {
    let title: String
    var isExpanded: Bool
    var movies: [Movie]
    
    init(title: String, isExpanded: Bool, movies: [Movie]) {
        self.title = title
        self.isExpanded = isExpanded
        self.movies = movies
    }
}

enum RowType {
    case category(title: String, isExpanded: Bool)
    case subcategory(subcategory: SubCategories)
    case movie(movie: Movie)
}

enum Filters: String {
    case ascending = "Ascending"
    case descending = "Descending"
}
