//
//  DiaryManager.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 26/05/2025.
//

import Foundation

class DiaryManager: ObservableObject {
    static let shared = DiaryManager()
    
    @Published var entries: [DiaryEntry] = []
    
    private let entriesKey = "diary_entries"
    
    private init() {
        loadEntries()
    }
    
    func addEntry(quote: Quote, reflection: String) {
        if let index = entries.firstIndex(where: { $0.quote == quote }) {
            entries[index].reflections.append(Reflection(text: reflection, date: Date()))
        } else {
            let newEntry = DiaryEntry(quote: quote, reflections: [Reflection(text: reflection, date: Date())])
            entries.append(newEntry)
        }
        saveEntries()
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
            print("Saved \(entries.count) entries.")
        } else {
            print("Failed to encode entries.")
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data) {
            entries = decoded
            print("Loaded \(decoded.count) entries.")
        } else {
            print("No entries found or decoding failed.")
        }
    }
    
    func updateReflection(entryID: UUID, reflectionID: UUID, newText: String) {
        guard let entryIndex = entries.firstIndex(where: { $0.id == entryID }) else { return }
        guard let reflectionIndex = entries[entryIndex].reflections.firstIndex(where: { $0.id == reflectionID }) else { return }

        entries[entryIndex].reflections[reflectionIndex].text = newText
        saveEntries()
    }
    
    func getReflections(for quote: Quote) -> [Reflection] {
        return entries
            .filter { $0.quote.quote == quote.quote && $0.quote.author == quote.author }
            .flatMap { $0.reflections }
    }
    
    func deleteReflection(entryID: UUID, reflectionID: UUID) {
        guard let entryIndex = entries.firstIndex(where: { $0.id == entryID }) else { return }

        entries[entryIndex].reflections.removeAll { $0.id == reflectionID }

        if entries[entryIndex].reflections.isEmpty {
            entries.remove(at: entryIndex)
        }

        saveEntries()
    }
}
