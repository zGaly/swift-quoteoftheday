//
// FavoritesManager.swift
// QuoteOfTheDay
//
// Created by José Luís on 26/05/2025.
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favoritesByCategory: [String: [Quote]] = [:] {
        didSet {
            saveFavorites()
        }
    }

    var favorites: [Quote] {
        favoritesByCategory.flatMap { $0.value }
    }

    private let favoritesKey = "favorite_quotes_by_category"

    init() {
        loadFavorites()
    }

    func add(_ quote: Quote, to category: String) {
        var updatedQuote = quote
        updatedQuote.category = category

        for (existingCategory, quotes) in favoritesByCategory {
            if let index = quotes.firstIndex(where: { $0.quote == quote.quote && $0.author == quote.author }) {
                favoritesByCategory[existingCategory]?.remove(at: index)
                if favoritesByCategory[existingCategory]?.isEmpty == true {
                    favoritesByCategory.removeValue(forKey: existingCategory)
                }
            }
        }

        if favoritesByCategory[category] == nil {
            favoritesByCategory[category] = []
        }

        favoritesByCategory[category]?.append(updatedQuote)
    }

    func remove(_ quote: Quote) {
        for (category, quotes) in favoritesByCategory {
            if let index = quotes.firstIndex(where: { $0.quote == quote.quote && $0.author == quote.author }) {
                favoritesByCategory[category]?.remove(at: index)
                if favoritesByCategory[category]?.isEmpty == true {
                    favoritesByCategory.removeValue(forKey: category)
                }
                break
            }
        }
    }

    func contains(_ quote: Quote) -> Bool {
        for quotes in favoritesByCategory.values {
            if quotes.contains(where: { $0.quote == quote.quote && $0.author == quote.author }) {
                return true
            }
        }
        return false
    }

    func remove(at offsets: IndexSet, in category: String) {
        favoritesByCategory[category]?.remove(atOffsets: offsets)
        if favoritesByCategory[category]?.isEmpty == true {
            favoritesByCategory.removeValue(forKey: category)
        }
    }

    func categories(for quote: Quote) -> [String] {
        favoritesByCategory.compactMap { (key, quotes) in
            quotes.contains(quote) ? key : nil
        }
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoritesByCategory) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    private func loadFavorites() {
        if let saved = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([String: [Quote]].self, from: saved) {
            favoritesByCategory = decoded
        }
    }
    
    func move(_ quote: Quote, to category: String) {
        for (key, quotes) in favoritesByCategory {
            if let index = quotes.firstIndex(of: quote) {
                favoritesByCategory[key]?.remove(at: index)
            }
        }
        add(quote, to: category)
    }
    
    func removeCategory(_ category: String) {
        favoritesByCategory.removeValue(forKey: category)
    }

    func renameCategory(_ oldName: String, to newName: String) {
        guard oldName != newName,
              let quotes = favoritesByCategory.removeValue(forKey: oldName) else { return }
        favoritesByCategory[newName] = quotes
    }
}
