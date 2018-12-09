//
//  ViewController.swift
//  pregnancyPhoto
//
//  Created by Marcus on 05.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 12, height: 200)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.backgroundColor = .groupTableViewBackground
        cv.dataSource = self
        cv.register(PrefoCell.self, forCellWithReuseIdentifier: "PrefoCell")
        cv.register(SectionHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "SectionHeader")
        cv.contentInset = UIEdgeInsets(top: 8,
                                       left: 8,
                                       bottom: 68,
                                       right: 8)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.setTitle("Foto hinzufügen", for: .normal)
        button.layer.cornerRadius = 22
        button.backgroundColor = AppConfiguration.shared.color
        button.addTarget(self,
                         action: #selector(startCamera),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Du hast noch kein Foto gespeichert. Füge jetzt eines hinzu."
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel = StartViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.viewDelegate = self
        viewModel.setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    private func setupView() {
        navigationController?.navigationBar.barTintColor = AppConfiguration.shared.color
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        title = "prefo"
        view.addSubview(collectionView)
        view.addSubview(addPhotoButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupEmpty() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc
    func startCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        navigationController?.present(picker, animated: true, completion: nil)
    }

}

extension StartController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.prefos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let date = viewModel.prefos[section].key
        guard let prefo = viewModel.prefos[date] else { return 0 }
        return prefo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrefoCell", for: indexPath) as! PrefoCell
    
        let date = viewModel.prefos[indexPath.section].key
        guard let prefo = viewModel.prefos[date] else {
            return UICollectionViewCell()
        }
        cell.setupWithImage(prefo[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageZoom = ImageZoomController()
        let date = viewModel.prefos[indexPath.section].key
        guard let prefo = viewModel.prefos[date] else { return }
        imageZoom.setupDetail(prefo[indexPath.item])
        navigationController?.pushViewController(imageZoom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "SectionHeader",
                                                                         for: indexPath) as! SectionHeaderView
            let date = viewModel.prefos[indexPath.section].key
            header.setupHeaderWith(date)
            return header
        default:
            break
        }
        
        return UICollectionReusableView()
    }
}

extension StartController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let dateStr = viewModel.formatter.string(from: Date())
        let prefo = Prefo(date: dateStr, image: image)
        viewModel.add(prefo)
    }
}

extension StartController: StartViewDelegate {
    func showData() {
        emptyLabel.removeFromSuperview()
        collectionView.reloadData()
    }
    func showEmpty() {
        DispatchQueue.main.async {
            self.setupEmpty()
        }
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

