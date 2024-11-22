//
//  ContentLoader.swift
//  CineMate
//
//  Created by Ritika Gupta on 22/11/24.
//

import Foundation

struct MovieList {
    var movies: [Movie]
    let yearMovies: [String: [Movie]]
    let actorMovies: [String: [Movie]]
    let directorMovies: [String: [Movie]]
    let genreMovies: [String: [Movie]]
}

protocol MovieRepository {
    func fetchMovies() -> [Movie]
    func groupMovies(_ movies: [Movie]) -> MovieList
}

class DefaultMovieRepository: MovieRepository {
    func fetchMovies() -> [Movie] {
        let decoder = JSONDecoder()
        
        guard let fileURL = Bundle.main.url(forResource: Constants.fileName, withExtension: Constants.fileExtension),
              let data = try? Data(contentsOf: fileURL),
              let movies = try? decoder.decode([Movie].self, from: data) else {
            print("Error loading movie data from json file")
            return []
        }
        
        return movies.sorted(by: { $0.title < $1.title })
    }
    
    func groupMovies(_ movies: [Movie]) -> MovieList {
        let yearMovies = Dictionary(grouping: movies, by: { $0.year })
        var genreMovies: [String: [Movie]] = [:]
        var actorMovies: [String: [Movie]] = [:]
        var directorMovies: [String: [Movie]] = [:]
        
        func groupByCollection(collection: [Movie], extractor: (Movie) -> [String], target: inout [String: [Movie]]) {
            for movie in collection {
                for key in extractor(movie) {
                    let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
                    target[trimmedKey, default: []].append(movie)
                }
            }
        }
        
        groupByCollection(collection: movies, extractor: { $0.genreCollection }, target: &genreMovies)
        groupByCollection(collection: movies, extractor: { $0.actorCollection }, target: &actorMovies)
        groupByCollection(collection: movies, extractor: { $0.directorCollection }, target: &directorMovies)
        
        return MovieList(
            movies: movies,
            yearMovies: yearMovies,
            actorMovies: actorMovies,
            directorMovies: directorMovies,
            genreMovies: genreMovies
        )
    }
}
