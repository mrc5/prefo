//
//  AppDelegate.swift
//  pregnancyPhoto
//
//  Created by Marcus on 05.12.18.
//  Copyright © 2018 Marcus Hopp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        
        var startController: UIViewController!
        
        if AppConfiguration.shared.onboardingWasShown {
            startController = UINavigationController(rootViewController: StartController())
        } else {
            startController = OnboardingController()
        }
        
        window.rootViewController = startController
        window.makeKeyAndVisible()
    
        return true
    }
}

