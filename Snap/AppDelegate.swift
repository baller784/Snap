//
//  AppDelegate.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/10/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    static var main: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FIRApp.configure()
        setupNotifications()
        setupRootViewController()
        setupAppearance()
        window?.makeKeyAndVisible()
        return true
    }

    fileprivate func setupAppearance() {
        AppearanceHelpers.setupAppearance()
    }

    func switchToSignInScreen() {
        let navController = UINavigationController(rootViewController: LoginViewController.storyboardInstance)
        navController.isNavigationBarHidden = true
        window?.rootViewController = navController
    }

    func switchToMainViewController() {
        let listController = ViewController.storyboardInstance as! ViewController
        let navController = UINavigationController(rootViewController: listController)
        window?.rootViewController = navController
    }

    fileprivate func setupRootViewController() {
        if FIRAuth.auth()?.currentUser != nil {
            switchToMainViewController()
        } else {
            switchToSignInScreen()
        }
    }

    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            //handle error
        })
    }
}
