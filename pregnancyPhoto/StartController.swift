//
//  ViewController.swift
//  pregnancyPhoto
//
//  Created by Marcus on 05.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit
import Lottie
import Photos
import UserNotifications

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
    
    lazy var restrictedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Du hast prefo nicht erlaubt auf deine Fotos zuzugreifen."
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.startAnimating()
        ai.style = UIActivityIndicatorView.Style.whiteLarge
        ai.color = AppConfiguration.shared.color
        return ai
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
        button.setTitle("Fertig", for: .normal)
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
        button.setTitle("Abbrechen", for: .normal)
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
        picker.locale = Locale(identifier: "de")
        picker.addTarget(self,
                         action: #selector(datePickerValueChanged(_:)),
                         for: .valueChanged)
        return picker
    }()
    
    lazy var successAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "success")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let viewModel = StartViewModel.shared
    private var pickerDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNotificationButton()
        viewModel.viewDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForAuthorization()
        viewModel.setupData()
    }
    
    private func checkForAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                break
            case .restricted, .denied, .notDetermined:
                let title = "Fehler"
                let message = "Du hast prefo nicht erlaubt auf dein Fotoalbum zuzugreifen. Um Fotos aufnehmen und speichern zu können benötigen wir allerdings Zugriff benötigt. Bitte passe das in den Datenschutzeinstellungen deines iPhones an, um prefo zu nutzen."
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                
                DispatchQueue.main.async {
                    self.present(alert,
                                 animated: true,
                                 completion: nil)
                }
            }
        }
    }
    
    private func setupNotificationButton() {
        let barButton = UIBarButtonItem(image: UIImage(named: "notification"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(notificationButtonTapped))
        navigationItem.rightBarButtonItem = barButton
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
        view.addSubview(activityIndicator)
        coverView.addSubview(successAnimationView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            successAnimationView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            successAnimationView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            successAnimationView.widthAnchor.constraint(equalToConstant: 200),
            successAnimationView.heightAnchor.constraint(equalToConstant: 200)
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
    
    private func setupRescricted() {
        view.addSubview(restrictedLabel)
        
        NSLayoutConstraint.activate([
            restrictedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restrictedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            restrictedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            restrictedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc
    func startCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        navigationController?.present(picker, animated: true, completion: nil)
    }
    
    @objc
    func notificationButtonTapped() {
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
    func animateSuccess(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.frame = CGRect(x: 0,
                                            y: UIScreen.main.bounds.height,
                                            width: UIScreen.main.bounds.width,
                                            height: 274)
        }) { (_) in
            self.picker.removeFromSuperview()
            self.contentView.removeFromSuperview()
            completion()
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
    func datePickerValueChanged(_ sender: UIDatePicker) {
        pickerDate = sender.date
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
                        self.animateSuccess {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            self.successAnimationView.play(completion: { (_) in
                                self.successAnimationView.stop()
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.coverView.alpha = 0
                                }, completion: { (_) in
                                    self.coverView.removeFromSuperview()
                                })
                            })
                        }
                    }
                })
            }
        }
    }
    
    @objc
    func cancelButtonTapped() {
        closePicker()
    }
}

extension StartController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.prefos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.prefos[section].value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrefoCell", for: indexPath) as! PrefoCell
        let prefo = viewModel.prefos[indexPath.section].value[indexPath.item]
        cell.setupWithImage(prefo.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageZoom = ImageZoomController()
        let prefo = viewModel.prefos[indexPath.section].value[indexPath.item]
        imageZoom.setupDetail(prefo)
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
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let dateStr = viewModel.formatter.string(from: Date())
        let prefo = Prefo(date: dateStr, image: image)
        viewModel.add(prefo)

        picker.dismiss(animated: true, completion: nil)
    }
}

extension StartController: StartViewDelegate {
    func showRestricted() {
        activityIndicator.stopAnimating()
        emptyLabel.removeFromSuperview()
        
        DispatchQueue.main.async {
            self.setupRescricted()
        }
    }
    
    func showData() {
        activityIndicator.stopAnimating()
        emptyLabel.removeFromSuperview()
        restrictedLabel.removeFromSuperview()
        collectionView.reloadData()
    }
    
    func showEmpty() {
        activityIndicator.stopAnimating()
        restrictedLabel.removeFromSuperview()
        
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

