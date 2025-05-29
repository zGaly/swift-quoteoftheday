//
//  Quote.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import Foundation

struct Quote: Codable, Identifiable, Hashable {
    let id: UUID
    let quote: String
    let author: String
    var category: String?

    init(id: UUID = UUID(), quote: String, author: String, category: String? = nil) {
        self.id = id
        self.quote = quote
        self.author = author
        self.category = category
    }

    // Custom decoding to handle missing `id` from API
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quote = try container.decode(String.self, forKey: .quote)
        self.author = try container.decode(String.self, forKey: .author)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.id = UUID() // Generate a UUID if not present in API response
    }
    var quoteIdentifier: String {
        return quote + author
    }
}
