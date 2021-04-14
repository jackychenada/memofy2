//
//  NotificationReminder.swift
//  Memofy2
//
//  Created by JACKY on 12/04/21.
//

import Foundation

import UserNotifications

struct Notification {
    var id: String
    var title: String
    var datetime: DateComponents
}

class NotificationReminder {
    var notifications: [Notification] = []
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print("Pending Notif : ", notification)
            }
        }
    }
    
    func listDeliveredNotifications()
    {
        UNUserNotificationCenter.current().getDeliveredNotifications {
            notifications in
            
            for notification in notifications {
                print("Delivered Notif : ", notification)
            }
        }
    }
    
    func removeWithIdentifiers(identifier: [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
        print("Delete pending notif dengan identifier ", identifier)
    }
    
    func removeAllNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Deleted All Notif")
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self.requestAuthorization()
                print("access", settings.authorizationStatus)
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.body     = "Hey, your study time is available now!"
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler([.sound, .alert])
    }
}


