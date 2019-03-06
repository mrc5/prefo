//
//  SettingsFooterView.swift
//  pregnancyPhoto
//
//  Created by Marcus on 06.03.19.
//  Copyright © 2019 Marcus Hopp. All rights reserved.
//

import UIKit

class SettingsFooterView: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Made with love for my beautiful wife and the little nugget \n\n Version 1.0 Build 5"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
