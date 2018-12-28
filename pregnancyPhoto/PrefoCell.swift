//
//  PrefoCell.swift
//  pregnancyPhoto
//
//  Created by Marcus on 06.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit

class PrefoCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var chestView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppConfiguration.shared.color
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var chestLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
//        imageView.addSubview(chestView)
//        chestView.addSubview(chestLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            chestView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
//            chestView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
//            chestView.heightAnchor.constraint(equalToConstant: 30),
//            chestView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
//
//            chestLabel.centerXAnchor.constraint(equalTo: chestView.centerXAnchor),
//            chestLabel.centerYAnchor.constraint(equalTo: chestView.centerYAnchor),
//            chestLabel.leadingAnchor.constraint(equalTo: chestView.leadingAnchor, constant: 4),
//            chestLabel.topAnchor.constraint(equalTo: chestView.topAnchor, constant: 4),
//            chestLabel.trailingAnchor.constraint(equalTo: chestView.trailingAnchor, constant: -4),
//            chestLabel.bottomAnchor.constraint(equalTo: chestView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithImage(_ image: UIImage) {
        imageView.image = image
//        chestLabel.text = "83 cm"
    }
}
