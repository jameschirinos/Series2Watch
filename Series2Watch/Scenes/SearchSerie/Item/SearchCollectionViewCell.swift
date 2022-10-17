//
//  SearchCollectionViewCell.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var label: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.numberOfLines = 1
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
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupCell(model: SearchCollectionViewModel) {
        label.text = model.name
        guard let imageUrl = model.imageUrl, let url = URL(string: imageUrl) else { return }
        imageView.sd_setImage(with: url)
    }
}
