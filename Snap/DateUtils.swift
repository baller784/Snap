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

//var title = "New Event"
//var doneButtonTitle = "Create"
//
//if updatedList != nil {
//    title = "Update Event"
//    doneButtonTitle = "Update"
//}
//
//let alertController = UIAlertController(title: title, message: "Write your event name", preferredStyle: .alert)
//let createAction = UIAlertAction(title: doneButtonTitle, style: .default) { action in
//    let listName = alertController.textFields?.first?.text
//    
//    if updatedList != nil {
//        try! self.realm.write {
//            updatedList.name = listName!
//            
//        }
//    } else {
//        let newEventList = EventList()
//        newEventList.name = listName!
//        
//        try! self.realm.write {
//            self.realm.add(newEventList)
//        }
//    }
//    print(listName!)
//}
//
//alertController.addAction(createAction)
//createAction.isEnabled = false
//self.currentCreateAction = createAction
//
//alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//alertController.addTextField { textField in
//    textField.placeholder = "Enter event name"
//    self.inputTextField = textField
//    //            if updatedList != nil {
//    //                self.inputTextField?.text = updatedList.name
//    //            }
//}
