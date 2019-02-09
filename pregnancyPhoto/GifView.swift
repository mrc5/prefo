//
//  GifView.swift
//  pregnancyPhoto
//
//  Created by Marcus on 09.02.19.
//  Copyright © 2019 Marcus Hopp. All rights reserved.
//

import UIKit

class GifView: UIView {
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        stackView.backgroundColor = .green
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    private lazy var shareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .yellow
        
        return view
    }()
    
    private lazy var share: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(AppConfiguration.shared.color,
                             for: .normal)
        button.setTitle("Teilen",
                        for: .normal)
        button.addTarget(self,
                         action: #selector(didTapSharing),
                         for: .touchUpInside)
        
        button.backgroundColor = .black
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        addSubview(contentStackView)
        shareView.addSubview(share)
        contentStackView.addArrangedSubview(shareView)
        contentStackView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapSharing() {
        
    }
    
}
