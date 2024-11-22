//
//  MovieSortable.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation

protocol MovieSortable {
    func sort(
        content: inout MovieList,
        categories: inout [ExpandableCategories],
        searchResults: inout [Movie],
        filter: Filters
    )
}

class DefaultMovieSortable: MovieSortable {
    func sort(content: inout MovieList,
              categories: inout [ExpandableCategories],
              searchResults: inout [Movie],
              filter: Filters) {
        let sortComparator: (String, String) -> Bool = filter == .ascending ? (<) : (>)
        
        // Sort movies in content
        content.movies.sort(by: { sortComparator($0.title, $1.title) })
        
        // Sort search results
        searchResults.sort(by: { sortComparator($0.title, $1.title) })
        
        // Sort categories and subcategories
        categories = categories.map { category in
            category.subCategories = category.subCategories.map { subCategory in
                subCategory.movies.sort(by: { sortComparator($0.title, $1.title) })
                return subCategory
            }.sorted(by: { sortComparator($0.title, $1.title) })
            return category
        }
        
    }
}
