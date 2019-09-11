//
//  SettingsViewController.swift
//  pregnancyPhoto
//
//  Created by Marcus on 06.03.19.
//  Copyright © 2019 Marcus Hopp. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let data = [NSLocalizedString("SettingsViewController:Privacy", comment: "SettingsViewController:Privacy")]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCloseButton()
    }
    
    func setupCloseButton() {
        let closeButton = UIBarButtonItem(title: NSLocalizedString("SettingsViewController:CloseButtonTitle",
                                                                   comment: "SettingsViewController:CloseButtonTitle"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = AppConfiguration.shared.color
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.noBackButtonTitle()
        
        title = NSLocalizedString("SettingsViewController:Title", comment: "SettingsViewController:Title")
        
        view.addSubview(tableView)
        
        tableView.register(SettingsCell.self,
                           forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "SettingsFooter")
        tableView.estimatedRowHeight = 50
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.setupWith(data[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let webView = WebViewController()
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsFooter") as! SettingsFooterView
            return footer
        default:
            return nil
        }
    }
}
