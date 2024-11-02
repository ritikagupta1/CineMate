//
//  SearchMoviesViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation
protocol SearchViewModelDelegate: AnyObject {
    func toggleSectionExpansion(at index: Int)
}

protocol SearchViewModelProtocol: AnyObject {
    var movies: [Movie]? {get}
    var categories: [ExpandableCategories] {get}
    var delegate: SearchViewModelDelegate? {get set}
    
    func loadMovies()
    func numberOfSections() -> Int
    func getCellType(for indexPath: IndexPath) -> CellType
    func numberOfRowsInSection(_ section: Int) -> Int
    func heightForRow(_ indexPath: IndexPath) -> Double
    func toggleCategory(indexPath: IndexPath)
    func updateSearchResults(with query: String)
}


class SearchMoviesViewModel: SearchViewModelProtocol {
    private(set) var movies: [Movie]?
    // Filtered Movies
    private var yearMovies: [String: [Movie]] = [:]
    private var actorMovies: [String: [Movie]] = [:]
    private var directorMovies: [String: [Movie]] = [:]
    private var genreMovies: [String: [Movie]] = [:]
    
    private(set) var categories: [ExpandableCategories] = []
    
    
    weak var delegate: SearchViewModelDelegate?
    
    
    var isSearchActive: Bool = false
    private var searchResults: [Movie] = []
    
    func loadMovies() {
        // Load movies from json file in the bundle
        let decoder = JSONDecoder()
        
        guard let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let movies = try? decoder.decode([Movie].self, from: data) else {
            print("Error loading movie data from json file")
            return
        }
        
        self.movies = movies
        self.filterMovies(movies: movies)
        self.configureDataSource()
    }
    
    private func filterMovies(movies: [Movie]) {
        // Year Movies
        self.yearMovies = Dictionary(grouping: movies, by: {$0.year})
        
        // Genre Movies
        for movie in movies {
            for genre in movie.genreCollection {
                let genre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
                if var existingMovies = genreMovies[genre] {
                    existingMovies.append(movie)
                    genreMovies[genre] = existingMovies
                } else {
                    genreMovies[genre] = [movie]
                }
            }
        }
        
        // Actor Movies
        for movie in movies {
            for actor in movie.actorCollection {
                let actor = actor.trimmingCharacters(in: .whitespacesAndNewlines)
                if var existingMovies = actorMovies[actor] {
                    existingMovies.append(movie)
                    actorMovies[actor] = existingMovies
                } else {
                    actorMovies[actor] = [movie]
                }
            }
        }
        
        // Director Movies
        for movie in movies {
            for director in movie.directorCollection {
                let director = director.trimmingCharacters(in: .whitespacesAndNewlines)
                if var existingMovies = directorMovies[director] {
                    existingMovies.append(movie)
                    directorMovies[director] = existingMovies
                } else {
                    directorMovies[director] = [movie]
                }
            }
        }
    }
    
    private func configureDataSource() {
        self.categories = MovieCategories.allCases.map({ category in
            var options: [SubCategories] = []
            switch category {
            case .year:
                options = yearMovies.map({
                    SubCategories(title: $0.key, isExpanded: false, movies: $0.value)
                }).sorted(by: { $0.title < $1.title })
            case .genre:
                options = genreMovies.map({
                    SubCategories(title: $0.key, isExpanded: false, movies: $0.value)
                }).sorted(by: { $0.title < $1.title })
            case .director:
                options = directorMovies.map({
                    SubCategories(title: $0.key, isExpanded: false, movies: $0.value)
                }).sorted(by: { $0.title < $1.title })
            case .actor:
                options = actorMovies.map({
                    SubCategories(title: $0.key, isExpanded: false, movies: $0.value)
                }).sorted(by: { $0.title < $1.title })
            case .all:
                break
            }
            return ExpandableCategories(title: category.title, isExpanded: false, subCategories: options)
        })
    }
    
    func numberOfSections() -> Int {
        isSearchActive ? 1 : categories.count
    }
    
    // Centralises the logic for determining the cell type in the getCellType(for:) method, making the cellForRowAt implementation more concise.
    func getCellType(for indexPath: IndexPath) -> CellType {
        guard let movies = self.movies else {
            fatalError("Movies not present")
        }
        if isSearchActive {
            return .movie(movie: searchResults[indexPath.row])
        }
        
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            return .header(title: category.title, isExpanded: category.isExpanded, indentationLevel: 0)
        }
        if indexPath.section == MovieCategories.all.rawValue {
            return .movie(movie: movies[indexPath.row - 1 ])
        }
        
        var currentRow = 1
        for subcategory in category.subCategories {
            if indexPath.row == currentRow {
                return .header(title: subcategory.title, isExpanded: subcategory.isExpanded, indentationLevel: 1)
            }
            currentRow += 1
            
            let startIndex = currentRow
            let endIndex = startIndex + subcategory.movies.count - 1
            if subcategory.isExpanded {
                if indexPath.row >= startIndex && indexPath.row <= endIndex {
                    return .movie(movie: subcategory.movies[indexPath.row - startIndex])
                }
                currentRow += subcategory.movies.count
            }
            
        }
        fatalError("Invalid index path: \(indexPath)")
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let movies = movies else {
            fatalError("Movies not found")
        }
        
        if isSearchActive {
            return searchResults.count
        }
        
        let category = categories[section]
        
        if section == MovieCategories.all.rawValue {
            return category.isExpanded ? movies.count+1 : 1
        }
        
        if !category.isExpanded {
            return 1
        } else {
            var count = 1
            for subcategory in category.subCategories {
                count += 1
                if subcategory.isExpanded {
                    for _ in subcategory.movies {
                        count += 1
                    }
                }
            }
            return count
        }
    }
    
    func heightForRow(_ indexPath: IndexPath) -> Double {
        let cellType = getCellType(for: indexPath)
        switch cellType {
        case .header:
            return 40
        case .movie:
            return 220
        }
    }
    
    func toggleCategory(indexPath: IndexPath) {
        guard indexPath.section < categories.count else { return }
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            category.isExpanded.toggle()
            delegate?.toggleSectionExpansion(at: indexPath.section)
        }
        var currentRow = 1
        
        for subcategory in category.subCategories {
            if currentRow == indexPath.row {
                subcategory.isExpanded.toggle()
                delegate?.toggleSectionExpansion(at: indexPath.section)
            }
            currentRow += 1
            
            if subcategory.isExpanded {
                currentRow += subcategory.movies.count
            }
        }
    }
    
    func updateSearchResults(with query: String) {
        guard let movies = movies else {
            print("Movies not present")
            return
        }
        
        isSearchActive = !query.isEmpty
        searchResults = movies.filter { movie in
            movie.title.lowercased().contains(query.lowercased()) ||
            movie.actorCollection.contains(where: { $0.lowercased().contains(query)}) ||
            movie.directorCollection.contains(where: { $0.lowercased().contains(query)}) ||
            movie.genreCollection.contains(where: { $0.lowercased().contains(query)})
        }
    }
}

enum CellType {
    case header(title: String, isExpanded: Bool, indentationLevel: Int)
    case movie(movie: Movie)
}