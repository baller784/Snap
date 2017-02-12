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
import LocalAuthentication

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

    func askForTouchID() {
        let authenticationContext = LAContext()
        var error: NSError?

        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("You don't have TouchID. NISHEBROD!")
            return
        }

        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Scan your finger, please") { [unowned self] (success, error) in
            if success {
                self.switchToMainViewController()
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension AppDelegate {
    func errorMessageForLAErrorCode(errorCode: Int) -> String {

        var message = ""

        switch errorCode {

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."

        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = "Did not find error code on LAError object"

        }

        return message
    }
}
