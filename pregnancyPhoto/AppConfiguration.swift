//
//  AppConfiguration.swift
//  pregnancyPhoto
//
//  Created by Marcus on 08.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit

class AppConfiguration {
    static let shared = AppConfiguration()
    private let defaults = UserDefaults.standard
    
    
    let color = UIColor(red:0.97, green:0.51, blue:0.47, alpha:1.0)
    
    var onboardingWasShown: Bool {
        get {
            return defaults.bool(forKey: "onboardingWasShown")
        }
        set {
            defaults.set(newValue, forKey: "onboardingWasShown")
        }
    }
    
    var albumWasCreated: Bool {
        get {
            return defaults.bool(forKey: "albumWasCreated")
        }
        set {
            defaults.set(newValue, forKey: "albumWasCreated")
        }
    }
}
