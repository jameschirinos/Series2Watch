//
//  EpisodeDetailViewController.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    lazy var structureStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        sv.spacing = 8.0
        return sv
    }()
    
    lazy var backgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var numberLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        l.textColor = .black
        return l
    }()
    
    lazy var summaryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textColor = .black
        return l
    }()
    
    var viewModel: EpisodeDetailVMProtocol?
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            numberLabel.text = "Season \(episode.season) Ep \(episode.number)"
            let data = episode.summary.data(using: .utf8)!
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            let length = attributedString?.length ?? 1
            attributedString?.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(0..<length))
            attributedString?.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0), range: NSRange(0..<length))
            summaryLabel.attributedText = attributedString
            guard let imageUrl = episode.imageUrl, let url = URL(string: imageUrl) else {
                imageView.image = R.image.movies()
                return
            }
            imageView.sd_setImage(with: url, placeholderImage: R.image.movies())
        }
    }
    
    init(viewModel: EpisodeDetailVMProtocol) {
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
        viewModel?.getEpisodeInfo()
        view.backgroundColor = .white
    }
    
    func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = R.color.lightgrey()
        view.addSubview(structureStackView)
        structureStackView.addArrangedSubview(numberLabel)
        structureStackView.addArrangedSubview(summaryLabel)
    }
    
    func setupConstraints() {
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(imageView)
        view.addSubview(numberLabel)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        numberLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        
        structureStackView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 16.0).isActive = true
        structureStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        structureStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16).isActive = true
    }

    func setupBinding() {
        viewModel?.gotEpisodeDetail = { [weak self] episode in
            self?.episode = episode
        }
    }
    
}
