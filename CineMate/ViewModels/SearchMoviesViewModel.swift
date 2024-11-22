//
//  SearchMoviesViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    func loadMovies()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func toggleCategory(indexPath: IndexPath)
    func updateSearchResults(with query: String)
    func sort(filter: Filters)
    func getRowType(for indexPath: IndexPath) -> RowType
    
    var toggleSectionExpansion:  ((Int) -> Void)? {get set}
}


class SearchMoviesViewModel: SearchViewModelProtocol {
    private(set) var movies: [Movie]?
    
    // Filtered Movies
    private var yearMovies: [String: [Movie]] = [:]
    private var actorMovies: [String: [Movie]] = [:]
    private var directorMovies: [String: [Movie]] = [:]
    private var genreMovies: [String: [Movie]] = [:]
    
    private(set) var categories: [ExpandableCategories] = []
    private(set) var sectionDataSource: [[RowType]] = []
    
    var toggleSectionExpansion: ((Int) -> Void)?
   
    
    private(set) var currentSortOrder: Filters = .ascending
    
    var isSearchActive: Bool = false
    var searchResults: [Movie] = []
    
    func loadMovies() {
        // Load movies from json file in the bundle
        let decoder = JSONDecoder()
        
        guard let fileURL = Bundle.main.url(forResource: Constants.fileName, withExtension: Constants.fileExtension),
              let data = try? Data(contentsOf: fileURL),
              let movies = try? decoder.decode([Movie].self, from: data) else {
            print("Error loading movie data from json file")
            return
        }
        
        self.movies = movies
        self.filterMovies(movies: movies)
        self.configureDataSource()
        self.initialiseRows()
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
        self.categories = MovieCategories.allCases.map { category in
            let options: [SubCategories]
            
            switch category {
            case .year:
                options = mapAndSort(yearMovies)
            case .genre:
                options = mapAndSort(genreMovies)
            case .director:
                options = mapAndSort(directorMovies)
            case .actor:
                options = mapAndSort(actorMovies)
            case .all:
                self.movies = self.movies?.sorted(by: { $0.title < $1.title })
                options = []
            }
            
            return ExpandableCategories(title: category.title, isExpanded: false, subCategories: options)
        }
    }

    private func mapAndSort(_ movies: [String: [Movie]]) -> [SubCategories] {
        movies.map {
            SubCategories(
                title: $0.key,
                isExpanded: false,
                movies: $0.value.sorted(by: { $0.title < $1.title })
            )
        }.sorted(by: { $0.title < $1.title })
    }
    
    func sort(filter: Filters) {
        guard filter != currentSortOrder || !categories.isEmpty else { return }
        self.currentSortOrder = filter
        
        let sortComparator: (String, String) -> Bool = filter == .ascending ? (<) : (>)
        
        // Sort categories and subcategories
        self.categories = self.categories.map { category in
            category.subCategories = category.subCategories.map { subCategory in
                subCategory.movies = subCategory.movies.sorted(by: { sortComparator($0.title, $1.title) })
                return subCategory
            }.sorted(by: { sortComparator($0.title, $1.title) })
            return category
        }
        
        // Sort main movies and search results
        self.movies = self.movies?.sorted(by: { sortComparator($0.title, $1.title) })
        self.searchResults = self.searchResults.sorted(by: { sortComparator($0.title, $1.title) })
        
        self.updateRows()
    }
    
    func initialiseRows() {
        self.sectionDataSource = categories.map { category in
            [.category(title: category.title, isExpanded: category.isExpanded)]
        }
    }
    
    func numberOfSections() -> Int {
        isSearchActive ? 1 : sectionDataSource.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return isSearchActive ? searchResults.count : sectionDataSource[section].count
    }

    private func updateRows() {
        self.sectionDataSource = categories.map { category in
            guard let movies = movies else {
                print("Movies not present")
                return []
            }
            
            var row: [RowType] = [.category(title: category.title, isExpanded: category.isExpanded)]
            
            if !category.isExpanded {
               return row
            }
            
            if category.title == MovieCategories.all.title{
                for movie in movies {
                    row.append(.movie(movie: movie))
                }
                return row
            }
            
            for subCategory in category.subCategories {
                row.append(.subcategory(subcategory: subCategory))
                
                if subCategory.isExpanded {
                    for movie in subCategory.movies {
                        row.append(.movie(movie: movie))
                    }
                }
            }
            return row
        }
    }
    
    func toggleCategory(indexPath: IndexPath) {
        guard indexPath.section < categories.count else { return }
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            category.isExpanded.toggle()
            self.updateRows()
            self.toggleSectionExpansion?( indexPath.section)
        }
        var currentRow = 1
        
        for subcategory in category.subCategories {
            if currentRow == indexPath.row {
                subcategory.isExpanded.toggle()
                self.updateRows()
                self.toggleSectionExpansion?(indexPath.section)
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
        if isSearchActive {
            searchResults = movies.filter { movie in
                movie.title.lowercased().contains(query.lowercased()) ||
                movie.actorCollection.contains(where: { $0.lowercased().contains(query)}) ||
                movie.directorCollection.contains(where: { $0.lowercased().contains(query)}) ||
                movie.genreCollection.contains(where: { $0.lowercased().contains(query)})
            }.sorted(by: { currentSortOrder == .ascending ? $0.title < $1.title : $0.title > $1.title })
        } else {
            searchResults = []
        }
        
    }
    
    func getRowType(for indexPath: IndexPath) -> RowType {
        isSearchActive ? RowType.movie(movie: searchResults[indexPath.row]) :
        sectionDataSource[indexPath.section][indexPath.row]
    }
}
