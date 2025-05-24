//
//  SecretsManager.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import Foundation

class SecretsManager {
    static let shared = SecretsManager()
    
    private var secrets: [String: Any] = [:]
    
    private init() {
        if let url = Bundle.main.url(forResource: "secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url) {
            secrets = (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [String: Any] ?? [:]
        }
    }
    
    var apiKey: String {
        return secrets["API_KEY"] as? String ?? ""
    }
}
