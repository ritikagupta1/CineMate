//
//  ViewController.swift
//  CineMate
//
//  Created by Ritika Gupta on 29/10/24.
//

import UIKit
class MovieSearchVC: UIViewController, UISearchBarDelegate {
    var viewModel: SearchMoviesViewModel
    
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(MovieDescriptionCell.self, forCellReuseIdentifier: MovieDescriptionCell.identifier)
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        return tableView
    }()
    
    init(viewModel: SearchMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadMovies()
        configureVC()
        configureTableView()
        configureSearchController()
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
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.searchBarPlaceHolder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension MovieSearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.getCellType(for: indexPath)
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
        let cellType = viewModel.getCellType(for: indexPath)
        switch cellType {
        case .header :
            self.viewModel.toggleCategory(indexPath: indexPath)
        case .movie(let movie):
            let detailVC = MovieDetailViewController(viewModel: MovieDetailsViewModel(movie: movie))
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(indexPath)
    }
}

extension MovieSearchVC: SearchViewModelDelegate {
    func toggleSectionExpansion(at index: Int) {
        self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
    }
}

extension MovieSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }
        viewModel.updateSearchResults(with: query)
        self.tableView.reloadData()
    }
}
