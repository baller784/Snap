//
//  AppearanceHelpers.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/14/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit

class AppearanceHelpers {
    class func setupAppearance() {
        let windowAppearance = UIWindow.appearance()
        let navBarAppearance = UINavigationBar.appearance()
        let tabBarItemAppearance = UITabBarItem.appearance(whenContainedInInstancesOf: [ViewController.self])
        
        windowAppearance.tintColor = .lightGray
        
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = .lightGray
        navBarAppearance.tintColor = .white
        navBarAppearance.isTranslucent = false
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.backgroundColor = .lightGray
        
        let selectedTabBarAttributes = [ NSForegroundColorAttributeName : UIColor.lightGray ]
        tabBarItemAppearance.setTitleTextAttributes(selectedTabBarAttributes, for: .selected)
    }
}

