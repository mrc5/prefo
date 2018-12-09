//
//  OnboardingController.swift
//  pregnancyPhoto
//
//  Created by Marcus on 08.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit
import Photos
import UserNotifications

class OnboardingController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3,
                                        height: UIScreen.main.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = .white
        picker.locale = Locale(identifier: "de")
        picker.addTarget(self,
                         action: #selector(datePickerValueChanged(_:)),
                         for: .valueChanged)
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Fertig",
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: "Abbrechen",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelButtonTapped))
        toolBar.setItems([cancelButton,
                          spaceButton,
                          doneButton],
                         animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    private var pickerDate: Date?
    
    private let viewModel = StartViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppConfiguration.shared.onboardingWasShown = true
        setupView()
        addData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        view.backgroundColor = AppConfiguration.shared.color
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func addData() {
        let views = [UIView(), UIView(), UIView()]
        
        for i in 0 ..< views.count {
            views[i].backgroundColor = .white
            views[i].layer.cornerRadius = 10
            
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i) + 16,
                                    y: UIScreen.main.bounds.height / 2 - 200,
                                    width: UIScreen.main.bounds.width - 32,
                                    height: 400)
            scrollView.addSubview(views[i])

            switch i {
            case 0:
                let label = CustomTextLabel().returnLabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Willkommen bei prefo. Mit dieser App kannst du deine Schwangerschaft mit einfachen Schnappschüssen dokumentieren."
                views[i].addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: views[i].centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: views[i].centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -16)
                ])
            case 1:
                let label = CustomTextLabel().returnLabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Um deine Bilder speichern zu können benötigen wird Zugriff auf dein Fotoalbum."
                views[i].addSubview(label)
                
                let image = UIImageView(image: UIImage(named: "photo_lib")?.withRenderingMode(.alwaysTemplate))
                image.tintColor = AppConfiguration.shared.color
                image.translatesAutoresizingMaskIntoConstraints = false
                views[i].addSubview(image)
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle("Album anlegen", for: .normal)
                button.backgroundColor = AppConfiguration.shared.color
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.darkGray, for: .highlighted)
                button.layer.cornerRadius = 10
                button.addTarget(self,
                                 action: #selector(addAlbumButtonTapped),
                                 for: .touchUpInside)
                
                views[i].addSubview(button)
                
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: views[i].centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: views[i].centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -16),
                    
                    image.centerXAnchor.constraint(equalTo: views[i].centerXAnchor),
                    image.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -24),
                    image.heightAnchor.constraint(equalToConstant: 100),
                    image.widthAnchor.constraint(equalToConstant: 100),
                    
                    button.leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 24),
                    button.trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -24),
                    button.heightAnchor.constraint(equalToConstant: 44),
                    button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24)
                    ])
            case 2:
                let label = CustomTextLabel().returnLabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Am einfachsten erstellst du einfach jede Woche um die gleiche Zeit eine Erinnerung."
                views[i].addSubview(label)
                
                let image = UIImageView(image: UIImage(named: "event")?.withRenderingMode(.alwaysTemplate))
                image.tintColor = AppConfiguration.shared.color
                image.translatesAutoresizingMaskIntoConstraints = false
                views[i].addSubview(image)
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle("Erinnerung anlegen", for: .normal)
                button.backgroundColor = AppConfiguration.shared.color
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.darkGray, for: .highlighted)
                button.layer.cornerRadius = 10
                button.addTarget(self,
                                 action: #selector(addNotificationTapped),
                                 for: .touchUpInside)
                
                views[i].addSubview(button)
                
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: views[i].centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: views[i].centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -16),
                    
                    image.centerXAnchor.constraint(equalTo: views[i].centerXAnchor),
                    image.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -24),
                    image.heightAnchor.constraint(equalToConstant: 100),
                    image.widthAnchor.constraint(equalToConstant: 100),
                    
                    button.leadingAnchor.constraint(equalTo: views[i].leadingAnchor, constant: 24),
                    button.trailingAnchor.constraint(equalTo: views[i].trailingAnchor, constant: -24),
                    button.heightAnchor.constraint(equalToConstant: 44),
                    button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24)
                ])
            default:
                continue
            }
        }
    }
    
    @objc
    private func addAlbumButtonTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.createPhotoLibraryAlbum("prefo")
            case .denied:
                let title = "Fehler"
                let message = "Du hast prefo nicht gestattet dein Fotoalbum zu nutzen. Bitte gibt die erlaubnis und kehre hierher zurück."
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok",
                                           style: .default,
                                           handler: nil)
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case .notDetermined:
                break
            case .restricted:
                break
            }
        }
    }
    
    private func createPhotoLibraryAlbum(_ name: String) {
        var albumExists = false
        
        var albumPlaceholder: PHObjectPlaceholder?
        let albumlist = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                subtype: .albumRegular,
                                                                options: nil)
    
        albumlist.enumerateObjects { (collection, _, _) in
            if collection.localizedTitle == name {
                albumExists = true
            }
        }
        
        if albumExists == false {
            PHPhotoLibrary.shared().performChanges({
                // Request creating an album with parameter name
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
                // Get a placeholder for the new album
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                
                if let error = error {
                    // failed with error!
                    print(error.localizedDescription)
                }
                
                if success {
                    guard let placeholder = albumPlaceholder else {
                        fatalError("Album placeholder is nil")
                    }
                    
                    let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                    guard let album: PHAssetCollection = fetchResult.firstObject else {
                        // FetchResult has no PHAssetCollection
                        return
                    }
                    // Saved successfully!
                    print(album.assetCollectionType)
                    
                    DispatchQueue.main.async {
                        self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2,
                                                                 y: 0),
                                                         animated: true)
                    }
                } else {
                    
                }
            })
        } else {
            print("Album \(name) already exists and was not created!")
            
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2,
                                                         y: 0),
                                                 animated: true)
            }
        }
    }
    
    @objc
    private func addNotificationTapped() {
        view.addSubview(picker)
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.heightAnchor.constraint(equalToConstant: 200),
            
            toolBar.bottomAnchor.constraint(equalTo: picker.topAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    func doneButtonTapped() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { (success, error) in
            if let err = error {
                print(err.localizedDescription)
            }
        
            if success {
                let content = UNMutableNotificationContent()
                content.title = "Fototime 😍🤰"
                content.body = "Es ist wieder soweit ein neues Fotos von deinem Bäuchlein zu machen."
                content.sound = .default
                
                let date = self.pickerDate ?? Date()
            
                let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second,],
                                                                    from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly,
                                                            repeats: true)
                
                let identifier = "PhotoNotification"
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content,
                                                    trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        self.picker.removeFromSuperview()
                        self.toolBar.removeFromSuperview()
                        self.startContentController()
                    }
                })
            }
        }
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker){
        self.pickerDate = sender.date
    }
    
    private func startContentController() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate,
            let window = delegate.window else { return }
        
        window.rootViewController = UINavigationController(rootViewController: StartController())
        window.makeKeyAndVisible()
    }
    
    @objc
    func cancelButtonTapped() {
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
}

extension OnboardingController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

class CustomTextLabel: UILabel {
    
    func returnLabel() -> UILabel {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 24,
                                           weight: UIFont.Weight.regular)
        textLabel.textColor = .darkGray
        return textLabel
    }
}
