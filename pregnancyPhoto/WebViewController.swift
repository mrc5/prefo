//
//  WebViewController.swift
//  pregnancyPhoto
//
//  Created by Marcus on 06.03.19.
//  Copyright © 2019 Marcus Hopp. All rights reserved.
//

import WebKit

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func configureView(_ type: String) {
        title = type
        
        var urlString = "https://www.iubenda.com/privacy-policy/40351588"
        
        switch type {
        case "Privacy":
            if let currentLanguage = Locale.current.languageCode {
                if currentLanguage == "en" {
                    urlString = "https://www.iubenda.com/privacy-policy/40351588"
                } else if currentLanguage == "de" {
                    urlString = "https://www.iubenda.com/privacy-policy/38110291"
                }
            }
            
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            
            webView.load(request)
        case "Licences":
            print("Licences")
        default:
            break
        }
    }
    
    
    
    private func setupView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.backgroundColor = .white
    }
}
