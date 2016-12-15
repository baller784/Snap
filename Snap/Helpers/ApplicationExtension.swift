//
//  ApplicationExtension.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appDelegate: AppDelegate {
        return self.shared.delegate as! AppDelegate
    }
}

