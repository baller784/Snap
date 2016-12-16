//
//  NotificationManager.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func notificationWithTimeInterval(with eventTitle: String, description: String) {
        let content = UNMutableNotificationContent()
        content.title = "Snap"
        content.subtitle = "\(eventTitle) has been added by you! 😜"
        content.body = description
        content.badge = 1
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            print("\(error?.localizedDescription)")
        })
    }
}
