//
//  Quote.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import Foundation

struct Quote: Codable, Identifiable {
    var id: UUID { UUID() }
    let quote: String
    let author: String
    var category: String?
}
