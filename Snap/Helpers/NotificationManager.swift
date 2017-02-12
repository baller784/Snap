//
//  NotificationManager.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationType {
    case image
    case sound
    case video
}

class NotificationManager: NSObject {
    static let shared = NotificationManager()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func addNotification(_ title: String, description: String, type: NotificationType) {
        var contentTitle = ""
        var contentDescription = ""
        var url: URL?

        switch type {
        case .image:
            contentTitle = "\(title) has been added by you! 😜"
            contentDescription = description
            url = Bundle.main.url(forResource: "default", withExtension: "jpg")
        default:
            break
        }

        let content = addNotificationContent(with: contentTitle, description: contentDescription)

        do {
            let attachment = try UNNotificationAttachment(identifier: "attach", url: url!, options: nil)
            content.attachments = [attachment]
            self.addDelayNotificationWith(content)
        } catch {
            print("attachment error")
        }
    }

    fileprivate func addNotificationContent(with title: String, description: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Snap"
        content.subtitle = title
        content.body = description
        content.badge = 1
        content.sound = UNNotificationSound.default()

        return content
    }

    fileprivate func addDelayNotificationWith(_ content: UNNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            print("\(error?.localizedDescription)")
        })
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Present Notification")
        completionHandler([.sound, .alert])
    }
}
