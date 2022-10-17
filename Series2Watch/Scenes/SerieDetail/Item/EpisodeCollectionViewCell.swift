//
//  EpisodeCollectionViewCell.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    lazy var structureStackView: UIStackView = { // numberLabel -> episodeStackView
        var sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var numberLabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()
    
    lazy var episodeStackView: UIStackView = { // horizontalStackView(image, title) -> summary
        var sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillProportionally
        sv.axis = .vertical
        return sv
    }()
    
    lazy var titleStackView: UIStackView = { // image -> title
        var sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var namelabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        l.textColor = .black
        return l
    }()
    
    lazy var summaryLabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.numberOfLines = 4
        l.textColor = .black
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        episodeStackView.addArrangedSubview(namelabel)
        episodeStackView.addArrangedSubview(summaryLabel)
        summaryLabel.trailingAnchor.constraint(equalTo: episodeStackView.trailingAnchor, constant: -8.0).isActive = true
        
        namelabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        summaryLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        titleStackView.addArrangedSubview(imageView)
        titleStackView.spacing = 8
        imageView.widthAnchor.constraint(equalToConstant: 110.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 110.0).isActive = true
        
        titleStackView.addArrangedSubview(episodeStackView)
        
         contentView.addSubview(structureStackView)
        structureStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        structureStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        structureStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        structureStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        structureStackView.heightAnchor.constraint(equalToConstant: 110.0).isActive = true
        
        structureStackView.addArrangedSubview(numberLabel)
        numberLabel.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
        structureStackView.addArrangedSubview(titleStackView)
        
        structureStackView.backgroundColor = R.color.lightgrey()
        structureStackView.layer.cornerRadius = 12.0
        
    }
    
    func setupCell(model: EpisodeCollectionViewModel) {
        namelabel.text = model.name
        let data = model.summary.data(using: .utf8)!
        let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let length = attributedString?.length ?? 1
        attributedString?.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(0..<length))
        attributedString?.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0), range: NSRange(0..<length))
        summaryLabel.attributedText = attributedString
        numberLabel.text = model.number
        guard let imageUrl = model.imageUrl, let url = URL(string: imageUrl) else {
            imageView.image = R.image.movies()
            return 
        }
        imageView.sd_setImage(with: url, placeholderImage: R.image.movies())
    }
    
}
