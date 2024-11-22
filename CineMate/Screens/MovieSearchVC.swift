//
//  ViewController.swift
//  CineMate
//
//  Created by Ritika Gupta on 29/10/24.
//

import UIKit
class MovieSearchVC: UIViewController, UISearchBarDelegate {
    let viewModel: SearchViewModelProtocol
    
    let tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(MovieDescriptionCell.self, forCellReuseIdentifier: MovieDescriptionCell.identifier)
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        return tableView
    }()
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Filters.ascending.rawValue, Filters.descending.rawValue])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    init(viewModel: SearchViewModelProtocol) {
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
        configureTableViewAndSegmentControl()
        configureSearchController()
    }
    
    private func configureVC() {
        self.view.backgroundColor = .systemBackground
        self.title = Constants.searchControllerTitle
    }
    
    private func configureTableViewAndSegmentControl() {
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(segmentControl)
        self.view.addSubview(tableView)
        
        self.tableView.backgroundColor = .systemBackground
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        segmentControl.addTarget(self, action: #selector(segmentControlClicked(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            segmentControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            segmentControl.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.searchBarPlaceHolder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @objc func segmentControlClicked(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            viewModel.sort(filter: .ascending)
        } else {
            viewModel.sort(filter: .descending)
        }
        
        self.tableView.reloadData()
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
        let rowType = viewModel.getRowType(for: indexPath)
        switch rowType {
        case .category(let title, let isExpanded):
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
            cell?.setup(viewModel: OptionCellModel(title: title, indentationLevel: 0, isExpanded: isExpanded))
            return cell ?? UITableViewCell()
        
        case .subcategory(let subcategory):
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell
            cell?.setup(viewModel: OptionCellModel(title: subcategory.title, indentationLevel: 1, isExpanded: subcategory.isExpanded))
            return cell ?? UITableViewCell()
        
        case .movie(let movie):
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDescriptionCell.identifier, for: indexPath) as? MovieDescriptionCell
            cell?.configure(viewModel: MovieDescriptionCellModel(movie: movie))
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let rowType = viewModel.getRowType(for: indexPath)
        switch rowType {
        case .category, .subcategory :
            self.viewModel.toggleCategory(indexPath: indexPath)
        case .movie(let movie):
            let detailVC = MovieDetailViewController(viewModel: ContentDetailViewModel(content: movie))
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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
