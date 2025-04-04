//
//  Notifications.swift
//  classync-Student
//
//  Created by Adriel Dube on 4/1/25.
//


import SwiftUI
import UserNotifications

struct Notifications {
    
    static func initialize() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted.")
                } else {
                    print("Notification permission denied: \(String(describing: error))")
                }
            }
        }
    }
    
    
    // Check what notifications are pending
    static func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Number of pending notifications: \(requests.count)")
            for request in requests {
                print("- Notification ID: \(request.identifier)")
                print("  Title: \(request.content.title)")
                print("  Body: \(request.content.body)")
                print("  Trigger: \(String(describing: request.trigger))")
            }
        }
    }
    
  
    
    static func sendNotification(text: String, delay: Int = 2, timing: TimeInterval = 2, scheduledDate: Date = Date(), useCalendar: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = text
        content.sound = UNNotificationSound.default
        
        // Create a unique identifier for this notification
        let identifier = "Notification-\(UUID().uuidString)"
        
        var triggers: [UNNotificationTrigger] = []

        if useCalendar {
            // Use a calendar date trigger
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduledDate)
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            triggers.append(calendarTrigger)
            
            if scheduledDate < Date() {
                print("Yo: You've scheduled a notification for a time in the past!")
            } else {
                print("Notification scheduled for: \(scheduledDate)")
            }
        }
        
        if delay > 0 {
            // Use a delay-based trigger
            let delayTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
            triggers.append(delayTrigger)
            
            print("Notification scheduled after \(delay) seconds")
        }
        
        // Schedule all triggers
        for trigger in triggers {
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully with ID: \(identifier)")
                }
            }
        }
    }

}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    

}
