//
//  UINavigationExtension.swift
//  pregnancyPhoto
//
//  Created by Marcus on 09.02.19.
//  Copyright © 2019 Marcus Hopp. All rights reserved.
//


import UIKit

extension UINavigationItem {
    func noBackButtonTitle() {
        backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
