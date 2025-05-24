//
//  QuoteOfTheDayApp.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import SwiftUI

@main
struct QuoteOfTheDayApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    init() {
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.scheduleTestNotification()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
