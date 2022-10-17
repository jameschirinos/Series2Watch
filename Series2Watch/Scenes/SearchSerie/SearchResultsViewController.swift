//
//  SearchResultsViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import UIKit

protocol SearchResultDelegate: AnyObject {
    func searchResult(searchResult: SearchResultsViewController, pressedSerieWith id: Int)
}

class SearchResultsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>
    
    weak var delegate: SearchResultDelegate?
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    lazy var dataSource = makeDataSource()
    var searchItems: [SearchCollectionViewModel] = [] {
        didSet {
            applyInitialSnapshots()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchColCell")
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    let searchCollectionCellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, SearchCollectionViewModel> { cell, _, item in
        cell.setupCell(model: item)
    }
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            if let item = item as? SearchCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.searchCollectionCellRegistration, for: indexPath, item: item)
            }
            return UICollectionViewCell()
        }
    }
    
    func applyInitialSnapshots() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(searchItems, toSection: 0)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
        collectionView.dataSource = dataSource
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchItems[indexPath.row]
        delegate?.searchResult(searchResult: self, pressedSerieWith: item.id)
    }
    
}
