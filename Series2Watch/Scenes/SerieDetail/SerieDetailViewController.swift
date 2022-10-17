//
//  SerieDetailViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import UIKit

class SerieDetailViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>

    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var airedLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    lazy var summaryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        return l
    }()
    
    lazy var genresLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
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
            self.imageView.sd_setImage(with: URL(string: serie.posterUrl))
            self.airedLabel.text = "Aired: \(serie.timeAirs)"
            let data = serie.summary.data(using: .utf8)!
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            let length = attributedString?.length ?? 1
            attributedString?.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0), range: NSRange(0..<length))
            self.summaryLabel.attributedText = attributedString
            let genresText = serie.genres.joined(separator: ", ")
            self.genresLabel.text = "Genres: \(genresText)"
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(airedLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(activityIndicator)
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.register(SeasonCollectionViewCell.self, forCellWithReuseIdentifier: "SeasonCell")
    }
    
    func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        airedLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0).isActive = true
        airedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        airedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
        genresLabel.topAnchor.constraint(equalTo: airedLabel.bottomAnchor, constant: 16.0).isActive = true
        genresLabel.leadingAnchor.constraint(equalTo: airedLabel.leadingAnchor).isActive = true
        genresLabel.trailingAnchor.constraint(equalTo: airedLabel.trailingAnchor).isActive = true
        
        summaryLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 20.0).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 0.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1000.0)
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
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            if let item = item as? EpisodeCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.episodeCollectionCellRegistration, for: indexPath, item: item)
            }
            if let item = item as? SeasonCollectionViewModel {
                return collectionView.dequeueConfiguredReusableCell(using: self.seasonCollectionCellRegistration, for: indexPath, item: item)
            }
            return UICollectionViewCell()
        }
    }
    
    func applyInitialSnapshots() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        let seasons = serie?.seasons ?? 1
        initialSnapshot.appendSections(Array(1...seasons))
        for i in 1...seasons {
            let filtered = episodesItems.filter({ Int($0.season) == i })
            var aux: [AnyHashable] = filtered
            aux.insert(SeasonCollectionViewModel(number: String(i)), at: 0)
            initialSnapshot.appendItems(aux, toSection: i)
        }
        dataSource.apply(initialSnapshot, animatingDifferences: false)
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
        let filtered = episodesItems.filter({ Int($0.season) == indexPath.section + 1 })
        let episode = Episode(episodeViewModel: filtered[indexPath.row - 1])
        viewModel?.goToEpisodeDetail(episode: episode)
    }
}
