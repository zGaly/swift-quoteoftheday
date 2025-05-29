//
//  Reflection.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 28/05/2025.
//

import Foundation

struct Reflection: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    let date: Date

    init(id: UUID = UUID(), text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
    var quoteIdentifier: String {
        return text + date.description
    }
}
