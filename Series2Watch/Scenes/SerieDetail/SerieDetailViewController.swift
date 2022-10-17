//
//  SerieDetailViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import UIKit

class SerieDetailViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    lazy var dataSource = makeDataSource()
    var viewModel: SerieDetailViewModel?
    var collectionHeightConstraint: NSLayoutConstraint?
    var episodesItems: [EpisodeCollectionViewModel] = []
    var serie: Serie? {
        didSet {
            guard let serie = serie else { return }
            self.episodesItems = serie.episodes.map(EpisodeCollectionViewModel.init)
            applyInitialSnapshots()
        }
    }
    
    init(viewModel: SerieDetailViewModel) {
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
        view.backgroundColor = .white
        
        Task {
            do {
                await viewModel?.getSerieDetail()
            }
        }
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.collectionHeightConstraint?.constant = newsize.height
            }
        }
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.register(SeasonCollectionViewCell.self, forCellWithReuseIdentifier: "SeasonCell")
        collectionView.register(EpisodeImageCollectionViewCell.self, forCellWithReuseIdentifier: "EpImageCell")
        collectionView.register(EpisodeDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: "EpDescCell")
    }
    
    func setupConstraints() {
        collectionView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 0.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1.0)
        collectionHeightConstraint?.isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupBinding() {
        viewModel?.gotSerieDetail = { [weak self] serie in
            DispatchQueue.main.async {
                self?.serie = serie
            }
        }
        
        viewModel?.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    let episodeCollectionCellRegistration = UICollectionView.CellRegistration<EpisodeCollectionViewCell, EpisodeCollectionViewModel> { cell, _, item in
        cell.setupCell(model: item)
    }
    
    let seasonCollectionCellRegistration = UICollectionView.CellRegistration<SeasonCollectionViewCell, SeasonCollectionViewModel> { cell, _, item in
        cell.setupCell(model: item)
    }
    
    let episodeImageCollectionCellRegistration = UICollectionView.CellRegistration<EpisodeImageCollectionViewCell, EpisodeImageCollectionViewModel> { cell, _, item in
        cell.setupCell(model: item)
    }
    
    let episodeDescriptionCollectionCellRegistration = UICollectionView.CellRegistration<EpisodeDescriptionCollectionViewCell, EpisodeDescriptionCollectionViewModel> { cell, _, item in
        cell.setupCell(model: item)
    }
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            if let item = item as? EpisodeCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.episodeCollectionCellRegistration, for: indexPath, item: item)
            }
            if let item = item as? SeasonCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.seasonCollectionCellRegistration, for: indexPath, item: item)
            }
            if let item = item as? EpisodeDescriptionCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.episodeDescriptionCollectionCellRegistration, for: indexPath, item: item)
            }
            if let item = item as? EpisodeImageCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.episodeImageCollectionCellRegistration, for: indexPath, item: item)
            }
            return UICollectionViewCell()
        }
    }
    
    func applyInitialSnapshots() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        guard let serie = serie else { return }
        let seasons = serie.seasons
        initialSnapshot.appendSections(Array(0...seasons))
        initialSnapshot.appendItems([
            EpisodeImageCollectionViewModel(imageUrl: serie.posterUrl),
            EpisodeDescriptionCollectionViewModel(aired: serie.timeAirs, genres: serie.genres, summary: serie.summary)
        ], toSection: 0)
        for i in 1...seasons {
            let filtered = episodesItems.filter({ Int($0.season) == i })
            var aux: [AnyHashable] = filtered
            aux.insert(SeasonCollectionViewModel(number: String(i)), at: 0)
            initialSnapshot.appendItems(aux, toSection: i)
        }
        dataSource.apply(initialSnapshot, animatingDifferences: true)
        collectionView.dataSource = dataSource
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

extension SerieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filtered = episodesItems.filter({ Int($0.season) == indexPath.section })
        let episode = Episode(episodeViewModel: filtered[indexPath.row - 1])
        viewModel?.goToEpisodeDetail(episode: episode)
    }
}
