//
//  StartViewModel.swift
//  pregnancyPhoto
//
//  Created by Marcus on 06.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit
import Photos

protocol StartViewDelegate: class {
    func showData()
    func showEmpty()
    func showRestricted()
}

class StartViewModel {
    static let shared = StartViewModel()

    var prefos = [(key: String, value: [Prefo])]()
    private var prefo = [Prefo]()
    
    weak var viewDelegate: StartViewDelegate?
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    func add(_ prefo: Prefo) {
        save(photo: prefo.image, toAlbum: "prefo") { (success, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if success {
                self.setupData()
            }
        }
    }
    
    func groupData() {
        let groupedPrefos = Dictionary(grouping: prefo) {
            (element) -> String in
            return element.date
        }
        prefos = groupedPrefos.sorted(by: {
            formatter.date(from: $0.key)! > formatter.date(from: $1.key)!
        })
    }
    
    func setupData() {
        getAlbumFor("prefo") { (collection) in
            self.prefo.removeAll()
            self.prefos.removeAll()
            
            guard let album = collection else {
                // collection is nil, because the access to PhotoLib is undefined, denied or restricted
                self.viewDelegate?.showRestricted()
                return
            }
            let imageManager = PHCachingImageManager()
            let assetFetchResult = PHAsset.fetchAssets(in: album,
                                                       options: nil)
            
            if assetFetchResult.count != 0 {
                assetFetchResult.enumerateObjects({ (asset, int, _) in
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    /* For faster performance, and maybe degraded image */
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat
                    options.isNetworkAccessAllowed = true
                    options.isSynchronous = true
                    
                    imageManager.requestImage(for: asset,
                                              targetSize: imageSize,
                                              contentMode: .aspectFill,
                                              options: options,
                                              resultHandler: {
                                                (image, info) -> Void in
                                                /* The image is now available to us */
                                                
                                                guard let image = image else { return }
                                                guard let creationDate = asset.creationDate else { return }

                                                let prefo = Prefo(date: self.formatter.string(from: creationDate),
                                                                  image: image)

                                                self.prefo.append(prefo)
                    })
                })
                
                self.groupData()
                DispatchQueue.main.async {
                    self.viewDelegate?.showData()
                }
            } else {
                self.viewDelegate?.showEmpty()
            }
        }
    }
    
    func getAlbumFor(_ title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async { 
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            
            DispatchQueue.main.async {
                if let album = collections.firstObject {
                    completionHandler(album)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    private func save(photo: UIImage, toAlbum title: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbumFor(title) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
                    let assets = assetRequest.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    DispatchQueue.main.async {
                        completionHandler(success, error)
                    }
                })
            }
        }
    }
    
    private func getAssetFor(_ photo: UIImage) {
        
    }
}
