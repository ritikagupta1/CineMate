//
//  SearchMoviesViewModel.swift
//  CineMate
//
//  Created by Ritika Gupta on 02/11/24.
//

import Foundation

protocol MovieLoadable: AnyObject {
    func loadMovies()
}

protocol SectionCountable: AnyObject {
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
}

protocol Expandable: AnyObject {
    func toggleCategory(indexPath: IndexPath)
    var toggleSectionExpansion: ((Int) -> Void)? { get set }
}

protocol Searchable: AnyObject {
    func updateSearchResults(with query: String)
}

protocol Sortable: AnyObject {
    func sort(filter: Filters)
}

protocol RowTypeGetter: AnyObject {
    func getRowType(for indexPath: IndexPath) -> RowType
}

protocol SearchViewModelProtocol:
    MovieLoadable,
    SectionCountable,
    Expandable,
    Searchable,
    Sortable,
    RowTypeGetter {}


class SearchMoviesViewModel: SearchViewModelProtocol {
    private var content: MovieList?
    
    private var categories: [ExpandableCategories] = []
    private var sectionDataSource: [[RowType]] = []
    
    var toggleSectionExpansion: ((Int) -> Void)?
    
    private let movieRepository: MovieRepository
    private let movieDataSource: MoviesDataSource
    private let movieSearchable: MovieSearchable
    private let movieSortable: MovieSortable
    private let movieSectionExpander: MovieSectionExpander
    
    private(set) var currentSortOrder: Filters = .ascending
    
    var isSearchActive: Bool = false
    var searchResults: [Movie] = []
    
    init(movieRepository: MovieRepository = DefaultMovieRepository(),
         movieDataSource: MoviesDataSource = DefaultMoviesDataSource(),
         movieSearchable: MovieSearchable = DefaultMovieSearchable(),
         movieSortable: MovieSortable = DefaultMovieSortable(),
         movieSectionExpander: MovieSectionExpander = DefaultMovieSectionExpander()) {
        self.movieRepository = movieRepository
        self.movieDataSource = movieDataSource
        self.movieSearchable = movieSearchable
        self.movieSortable = movieSortable
        self.movieSectionExpander = movieSectionExpander
    }
    
    func loadMovies() {
        let fetchedContent = movieRepository.groupMovies(movieRepository.fetchMovies())
        self.content = fetchedContent
        self.categories = movieDataSource.getDataSource(content: fetchedContent)
        self.sectionDataSource = movieDataSource.updateDataSource(movies: fetchedContent.movies,
                                                                  categories: self.categories)
    }
    
    func numberOfSections() -> Int {
        isSearchActive ? 1 : sectionDataSource.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return isSearchActive ? searchResults.count : sectionDataSource[section].count
    }

    private func updateDataSource() {
        guard let movies = content?.movies else {
            print("Movies not present")
            sectionDataSource = []
            return
        }
        
        self.sectionDataSource = movieDataSource.updateDataSource(movies: movies, categories: self.categories)
    }
    
    
    func toggleCategory(indexPath: IndexPath) {
        var mutableCategories = categories
        let result = movieSectionExpander.toggleCategory(categories: &mutableCategories, indexPath: indexPath)
        
        if result {
            categories = mutableCategories
            // Trigger UI update for specific section
            self.updateDataSource()
            self.toggleSectionExpansion?( indexPath.section)
        }
    }
    
    func updateSearchResults(with query: String) {
        guard let movies = content?.movies else {
            print("Movies not present")
            return
        }
        
        isSearchActive = !query.isEmpty
        searchResults = movieSearchable.updateSearchResults(
            with: query,
            in: movies,
            currentSortOrder: currentSortOrder
        )
    }
    
    func sort(filter: Filters) {
        guard var mutableContent = content else { return }
        
        guard filter != currentSortOrder || !categories.isEmpty else { return }
        self.currentSortOrder = filter
        movieSortable.sort(
            content: &mutableContent,
            categories: &categories,
            searchResults: &searchResults,
            filter: filter
        )
        
        content = mutableContent
        self.updateDataSource()
    }
    
    func getRowType(for indexPath: IndexPath) -> RowType {
        isSearchActive ? RowType.movie(movie: searchResults[indexPath.row]) :
        sectionDataSource[indexPath.section][indexPath.row]
    }
}
