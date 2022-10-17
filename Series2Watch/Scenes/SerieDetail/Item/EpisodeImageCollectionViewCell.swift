//
//  EpisodeImageCollectionViewCell.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import UIKit

class EpisodeImageCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupCell(model: EpisodeImageCollectionViewModel) {
        imageView.sd_setImage(with: URL(string: model.imageUrl))
    }
    
}
