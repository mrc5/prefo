//
//  StartController.swift
//  pregnancyPhoto
//
//  Created by Marcus Hopp on 19.03.20.
//  Copyright © 2020 Marcus Hopp. All rights reserved.
//

import UIKit

enum Feature {
    case TakePhoto
    case Video
}

class StartController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var features = [Feature.TakePhoto,
                            Feature.Video]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeatureCell.self, forCellWithReuseIdentifier: "FeatureCell")
        
        view.addSubview(collectionView)
    }
}

extension StartController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeatureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
