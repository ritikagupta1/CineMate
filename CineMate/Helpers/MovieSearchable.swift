//
//  ContentFilter.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation

protocol MovieSearchable {
    func updateSearchResults(with query: String, in movies: [Movie], currentSortOrder: Filters) -> [Movie]
}

class DefaultMovieSearchable: MovieSearchable {
    func updateSearchResults(with query: String, in movies: [Movie], currentSortOrder: Filters) -> [Movie] {
        guard !query.isEmpty else { return [] }
        
        return movies.filter { movie in
            movie.title.lowercased().contains(query.lowercased()) ||
            movie.actorCollection.contains(where: { $0.lowercased().contains(query.lowercased()) }) ||
            movie.directorCollection.contains(where: { $0.lowercased().contains(query.lowercased()) }) ||
            movie.genreCollection.contains(where: { $0.lowercased().contains(query.lowercased()) })
        }.sorted(by: { currentSortOrder == .ascending ? $0.title < $1.title : $0.title > $1.title })
    }
}
