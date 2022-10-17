//
//  AllSeriesViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 14/10/22.
//

import UIKit

class AllSeriesViewController: UIViewController {

    typealias AllSeriesDataSource = UICollectionViewDiffableDataSource<Int, SerieCollectionViewModel>
    
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
    
    var viewModel: AllSeriesVMProtocol?
    var allSeries: [SerieCollectionViewModel] = []
    lazy var dataSource = makeDataSource()
    
    init(viewModel: AllSeriesVMProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBinding()
        
        Task {
            do {
                await viewModel?.getAllSeries()
            }
        }
    }
    
    func setupViews() {
        self.view.addSubview(collectionView)
        self.view.addSubview(activityIndicator)
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
        collectionView.register(SerieCollectionViewCell.self, forCellWithReuseIdentifier: "SerieColCell")
    }
    
    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupBinding() {
        viewModel?.gotAllSeries = { [weak self] allSeries in
            DispatchQueue.main.async {
                self?.allSeries = allSeries.map(SerieCollectionViewModel.init)
                self?.applyInitialSnapshots()
            }
        }
        
        viewModel?.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func makeDataSource() -> AllSeriesDataSource {
        let serieCollectionCellRegistration = serieCollectionCellRegistration()
        return AllSeriesDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: serieCollectionCellRegistration, for: indexPath, item: item)
        }
    }
    
    func serieCollectionCellRegistration() -> UICollectionView.CellRegistration<SerieCollectionViewCell, SerieCollectionViewModel> {
        return .init { cell, _, item in
            cell.setupCell(model: item)
        }
    }
    
    func applyInitialSnapshots() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, SerieCollectionViewModel>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(allSeries, toSection: 0)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
        collectionView.dataSource = dataSource
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let width = (UIScreen.main.bounds.width - 3*16) / 2
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16.0)
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(16.0), top: NSCollectionLayoutSpacing.fixed(8.0), trailing: NSCollectionLayoutSpacing.fixed(16.0), bottom: NSCollectionLayoutSpacing.fixed(8.0))
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension AllSeriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.goToDetail(serieID: allSeries[indexPath.row].id, serieName: allSeries[indexPath.row].name ?? "")
    }
    
}
