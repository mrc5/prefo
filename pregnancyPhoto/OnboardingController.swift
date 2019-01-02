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
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        coverView.alpha = 0
        return coverView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Picker:DoneButtonTitle", comment: "Done"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = AppConfiguration.shared.color
        button.layer.cornerRadius = 22
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        button.addTarget(self,
                         action: #selector(doneButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Picker:CancelButtonTitle", comment: "Cancel"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = AppConfiguration.shared.color
        button.layer.cornerRadius = 22
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    var contentView: UIView!
    
    lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = .white
        picker.locale = Locale.current
        picker.addTarget(self,
                         action: #selector(datePickerValueChanged(_:)),
                         for: .valueChanged)
        return picker
    }()
    
    private var pickerDate: Date?
    
    private let viewModel = StartViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                label.text = NSLocalizedString("OnboardingController:Welcome", comment: "Welcome")
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
                label.text = NSLocalizedString("OnboardingController:PhotoAuthorization", comment: "PhotoAuthorization")
                views[i].addSubview(label)
                
                let image = UIImageView(image: UIImage(named: "photo_lib")?.withRenderingMode(.alwaysTemplate))
                image.tintColor = AppConfiguration.shared.color
                image.translatesAutoresizingMaskIntoConstraints = false
                views[i].addSubview(image)
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle(NSLocalizedString("OnboardingController:CreateAlbumButtonTitle", comment: "CreateAlbum"), for: .normal)
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
                label.text = NSLocalizedString("OnboardingController:NotificationAuthorization", comment: "NotificationAuthorization")
                views[i].addSubview(label)
                
                let image = UIImageView(image: UIImage(named: "event")?.withRenderingMode(.alwaysTemplate))
                image.tintColor = AppConfiguration.shared.color
                image.translatesAutoresizingMaskIntoConstraints = false
                views[i].addSubview(image)
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle(NSLocalizedString("OnboardingController:CreateNotificationButtonTitle", comment: "CreateNotification"), for: .normal)
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
                let title = NSLocalizedString("Error:CreateAlbumAlertTitle", comment: "Error")
                let message = NSLocalizedString("Error:CreateAlbumAlertMessage", comment: "NoAuthorization")
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("Error:CreateAlbumAlertOKButtonTitle", comment: "OkButtonTitle"),
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
                    guard (fetchResult.firstObject != nil) else {
                        // FetchResult has no PHAssetCollection
                        return
                    }
                    
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
    func doneButtonTapped() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { (success, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            if success {
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("Notification:Title", comment: "NotificationTitle")
                content.body = NSLocalizedString("Notification:Body", comment: "NotificationBody")
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
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        UIView.animate(withDuration: 0.2, animations: {
                            self.coverView.alpha = 0
                        }, completion: { (_) in
                            self.closePicker()
                            AppConfiguration.shared.onboardingWasShown = true
                            self.startContentController()
                        })
                    }
                })
            }
        }
    }
    
    @objc
    func cancelButtonTapped() {
        closePicker()
    }
    
    @objc
    private func addNotificationTapped() {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate,
            let window = delegate.window else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePicker))
        coverView.addGestureRecognizer(tapGesture)
        window.addSubview(coverView)
        
        let targetY = window.frame.height - 274
        
        contentView = UIView(frame: CGRect(x: 0,
                                           y: window.frame.height,
                                           width: window.frame.width,
                                           height: 274))
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        coverView.addSubview(contentView)
        contentView.addSubview(picker)
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            coverView.topAnchor.constraint(equalTo: window.topAnchor),
            coverView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            coverView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            
            picker.heightAnchor.constraint(equalToConstant: 200),
            picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: 8),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: 8)
            ])
        
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame = CGRect(x: 0,
                                                y: targetY,
                                                width: window.frame.width,
                                                height: 274)
                self.picker.isHidden = false
            })
        }
    }
    
    @objc
    func closePicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.frame = CGRect(x: 0,
                                            y: UIScreen.main.bounds.height,
                                            width: UIScreen.main.bounds.width,
                                            height: 274)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.coverView.alpha = 0
            }, completion: { (_) in
                self.picker.removeFromSuperview()
                self.contentView.removeFromSuperview()
                self.coverView.removeFromSuperview()
            })
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
