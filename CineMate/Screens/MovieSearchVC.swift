//
//  ViewController.swift
//  CineMate
//
//  Created by Ritika Gupta on 29/10/24.
//

import UIKit

enum CellType {
    case header(title: String, isExpanded: Bool, indentationLevel: Int)
    case movie(movie: Movie)
}

class MovieSearchVC: UIViewController {
    private var movies: [Movie]?
    // Filtered Movies
    private var yearMovies: [String: [Movie]] = [:]
    private var actorMovies: [String: [Movie]] = [:]
    private var directorMovies: [String: [Movie]] = [:]
    private var genreMovies: [String: [Movie]] = [:]
    
    private var categories: [ExpandableCategories] = []
    
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(MovieDescriptionCell.self, forCellReuseIdentifier: MovieDescriptionCell.identifier)
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
        configureVC()
        configureTableView()
    }
    
    private func configureVC() {
        self.view.backgroundColor = .systemBackground
        self.title = "Search Movies"
    }
    
    private func configureTableView() {
        self.tableView.backgroundColor = .systemBackground
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func loadMovies() {
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
}


extension MovieSearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // Centralises the logic for determining the cell type in the getCellType(for:) method, making the cellForRowAt implementation more concise.
    func getCellType(for indexPath: IndexPath) -> CellType {
        guard let movies = self.movies else {
            fatalError("Movies not present")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = movies else {
            fatalError("Movies not found")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.getCellType(for: indexPath)
        switch cellType {
        case .header(let title, let isExpanded, let indentationLevel):
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
            cell?.setup(title: title, indentationLevel: indentationLevel, isExpanded: isExpanded)
            return cell ?? UITableViewCell()
            
        case .movie(let movie):
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDescriptionCell.identifier, for: indexPath) as? MovieDescriptionCell
            cell?.configure(with: movie)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = getCellType(for: indexPath)
        switch cellType {
        case .header :
            let category = categories[indexPath.section]
            if indexPath.row == 0 {
                category.isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
            var currentRow = 1
            
            for subcategory in category.subCategories {
                if currentRow == indexPath.row {
                    subcategory.isExpanded.toggle()
                    self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
                currentRow += 1
                
                if subcategory.isExpanded {
                    currentRow += subcategory.movies.count
                }
            }
        case .movie(let movie):
            let detailVC = MovieDetailViewController(movie: movie)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = getCellType(for: indexPath)
        switch cellType {
        case .header:
            return 40
        case .movie:
            return 220
        }
    }
}
