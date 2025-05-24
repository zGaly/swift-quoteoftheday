import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favoritesByCategory: [String: [Quote]] = [:] {
        didSet {
            saveFavorites()
        }
    }

    private let favoritesKey = "favorite_quotes_by_category"

    init() {
        loadFavorites()
    }

    func add(_ quote: Quote, to category: String) {
        var updatedQuote = quote
        updatedQuote.category = category

        if favoritesByCategory[category] == nil {
            favoritesByCategory[category] = []
        }

        if !favoritesByCategory[category]!.contains(where: { $0.quote == quote.quote && $0.author == quote.author }) {
            favoritesByCategory[category]!.append(updatedQuote)
        }
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
        favoritesByCategory.filter { $0.value.contains(where: { $0.quote == quote.quote && $0.author == quote.author }) }.map { $0.key }
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
}
