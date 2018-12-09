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
}

class StartViewModel {
    static let shared = StartViewModel()

    var prefos = [String: [Prefo]]()
    var prefo = [Prefo]()
    
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
                self.prefos[prefo.date]?.append(prefo)
                self.viewDelegate?.showData()
            }
        }
    }
    
    func groupData() {
        let groupedPrefos = Dictionary(grouping: prefo) { (element) -> String in
            return element.date
        }
        self.prefos = groupedPrefos
    }
    
    func getPrefoCount(_ section: Int) -> Int {
        var count: Int?
        
        prefos.keys.forEach { (date) in
            count = prefos[date]?.count
        }
        
        return count ?? 0
    }
    
    func setupData() {
        getAlbumFor("prefo") { (collection) in
            guard let album = collection else { return }
            let imageManager = PHCachingImageManager()
            let assetFetchResult = PHAsset.fetchAssets(in: album,
                                                       options: nil)
            
            if assetFetchResult.count != 0 {
                assetFetchResult.enumerateObjects({ (asset, int, _) in
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    /* For faster performance, and maybe degraded image */
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isSynchronous = true
                    
                    imageManager.requestImage(for: asset,
                                              targetSize: imageSize,
                                              contentMode: .aspectFill,
                                              options: options,
                                              resultHandler: {
                                                (image, _) -> Void in
                                                /* The image is now available to us */
                                                guard let image = image,
                                                    let creationDate = asset.creationDate else { return }

                                                let prefo = Prefo(date: self.formatter.string(from: creationDate),
                                                                  image: image)
                                                self.prefo.append(prefo)
                                                self.groupData()
                                                self.viewDelegate?.showData()
                    })
                })
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
                    //                self?.createAlbum(withTitle: title, completionHandler: { (album) in
                    //                    completionHandler(album)
                    //                })
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
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}


