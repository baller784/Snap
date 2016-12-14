//
//  ViewControllerExtensions.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/23/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit

protocol Layoutable {
    func layout()
}

protocol Styleable {
    func stylize()
}

extension UIViewController {
    static var storyboardInstance: UIViewController {
        return storyboardInstance(withTitle: "")
    }
    
    static func storyboardInstance(withTitle title: String) -> UIViewController {
        let classNameWithoutModule = NSStringFromClass(self).components(separatedBy: ".").last!
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: classNameWithoutModule)
        viewController.title = title
        return viewController
    }
}
