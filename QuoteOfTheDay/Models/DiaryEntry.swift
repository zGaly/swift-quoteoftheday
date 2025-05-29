//
//  DiaryEntry.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 26/05/2025.
//

import Foundation

struct DiaryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let quote: Quote
    var reflections: [Reflection]

    init(id: UUID = UUID(), quote: Quote, reflections: [Reflection]) {
        self.id = id
        self.quote = quote
        self.reflections = reflections
    }
}
