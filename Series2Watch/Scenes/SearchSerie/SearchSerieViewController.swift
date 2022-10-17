//
//  SearchSerieViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import UIKit

class SearchSerieViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var viewModel: SearchSerieViewModel?
    var searchController = UISearchController(searchResultsController: SearchResultsViewController())
    var series: [Serie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        setupBinding()
    }
    
    init(viewModel: SearchSerieViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBinding() {
        if let svc = searchController.searchResultsController as? SearchResultsViewController {
            svc.delegate = self
        }
        
        viewModel?.gotSerieSearch = { [weak self] series in
            DispatchQueue.main.async {
                self?.series = series
                guard let controller = self?.searchController.searchResultsController as? SearchResultsViewController else { return }
                controller.searchItems = series.map({ SearchCollectionViewModel(serie: $0) })
            }
            
        }
        
        viewModel?.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                guard let controller = self?.searchController.searchResultsController as? SearchResultsViewController else { return }
                isLoading ? controller.activityIndicator.startAnimating() : controller.activityIndicator.stopAnimating()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 3 else { return }
        self.searchController = searchController
        Task {
            do {
                await viewModel?.searchSerie(text: text)
            }
        }
    }

}

extension SearchSerieViewController: SearchResultDelegate {
    
    func searchResult(searchResult: SearchResultsViewController, pressedSerieWith id: Int) {
        let serie = series.first(where: { $0.id == id })
        viewModel?.coordinator.openSerieDetail(serieID: id, serieName: serie?.name ?? "")
    }
    
}
