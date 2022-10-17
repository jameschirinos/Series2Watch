//
//  EpisodeDescriptionCollectionViewCell.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import UIKit

class EpisodeDescriptionCollectionViewCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        contentView.addSubview(airedLabel)
        airedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0).isActive = true
        airedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        airedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
        contentView.addSubview(genresLabel)
        genresLabel.topAnchor.constraint(equalTo: airedLabel.bottomAnchor, constant: 16.0).isActive = true
        genresLabel.leadingAnchor.constraint(equalTo: airedLabel.leadingAnchor).isActive = true
        genresLabel.trailingAnchor.constraint(equalTo: airedLabel.trailingAnchor).isActive = true
        
        contentView.addSubview(summaryLabel)
        summaryLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 16.0).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: airedLabel.leadingAnchor).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: airedLabel.trailingAnchor).isActive = true
        summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    func setupCell(model: EpisodeDescriptionCollectionViewModel) {
        self.airedLabel.text = "Aired: \(model.aired)"
        let data = model.summary.data(using: .utf8)!
        let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let length = attributedString?.length ?? 1
        attributedString?.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0), range: NSRange(0..<length))
        self.summaryLabel.attributedText = attributedString
        let genresText = model.genres.joined(separator: ", ")
        self.genresLabel.text = "Genres: \(genresText)"
    }
    
    
    
}
