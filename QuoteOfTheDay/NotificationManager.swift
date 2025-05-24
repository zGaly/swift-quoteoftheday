//
//  NotificationManager.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                self.scheduleDailyQuoteNotification()
                // self.scheduleTestNotification() // Use this only during development
            }
        }
    }

    func scheduleDailyQuoteNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_quote_notification"])

        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"
        content.body = "Come check a new quote 🗣️💯"
        content.sound = .default

        let randomHour = Int.random(in: 9...21)
        let randomMinute = Int.random(in: 0...59)

        var dateComponents = DateComponents()
        dateComponents.hour = randomHour
        dateComponents.minute = randomMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "daily_quote_notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Quote of the day"
        content.body = "Come check a new quote 🗣️💯"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: "test_quote_notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
