//
//  ContentDataSource.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation
protocol MoviesDataSource {
    func getDataSource(content: MovieList) -> [ExpandableCategories]
    func updateDataSource(movies: [Movie], categories: [ExpandableCategories]) -> [[RowType]]
}

class DefaultMoviesDataSource: MoviesDataSource {
    func getDataSource(content: MovieList) -> [ExpandableCategories] {
        return MovieCategories.allCases.map { category in
            let options: [SubCategories]
            
            switch category {
            case .year:
                options = mapAndSort(content.yearMovies)
            case .genre:
                options = mapAndSort(content.genreMovies)
            case .director:
                options = mapAndSort(content.directorMovies)
            case .actor:
                options = mapAndSort(content.actorMovies)
            case .all:
                options = []
            }
            
            return ExpandableCategories(title: category.title, isExpanded: false, subCategories: options)
        }
    }
    
    
    func updateDataSource(movies: [Movie], categories: [ExpandableCategories]) -> [[RowType]] {
        return categories.map { category in
            var row: [RowType] = [.category(title: category.title, isExpanded: category.isExpanded)]
            
            guard category.isExpanded else { return row }
            
            if category.title == MovieCategories.all.title {
                row.append(contentsOf: movies.map { .movie(movie: $0) })
                return row
            }
            
            for subCategory in category.subCategories {
                row.append(.subcategory(subcategory: subCategory))
                
                if subCategory.isExpanded {
                    row.append(contentsOf: subCategory.movies.map { .movie(movie: $0) })
                }
            }
            
            return row
        }
    }
    
    
    // Helper function to map and sort movies
    private func mapAndSort(_ movies: [String: [Movie]]) -> [SubCategories] {
        movies.map {
            SubCategories(
                title: $0.key,
                isExpanded: false,
                movies: $0.value.sorted(by: { $0.title < $1.title })
            )
        }.sorted(by: { $0.title < $1.title })
    }
}
