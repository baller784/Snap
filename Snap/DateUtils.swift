//
//  DateUtils.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/12/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit

class DateUtils {
    
    class func convertDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        
        return dateFormatter.string(from: date)
    }
}
