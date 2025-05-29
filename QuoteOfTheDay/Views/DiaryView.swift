//
//  DiaryView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 26/05/2025.
//

import SwiftUI

struct DiaryView: View {
    @ObservedObject var diaryManager = DiaryManager.shared
    @State private var reflectionText: String = ""
    @State private var currentQuote: Quote? = nil
    @State private var searchText: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    private func filteredEntries() -> [DiaryEntry] {
        if searchText.isEmpty {
            return diaryManager.entries
        }

        let matchesText = diaryManager.entries.filter {
            $0.reflections.contains { $0.text.localizedCaseInsensitiveContains(searchText) }
        }

        let matchesCategory = diaryManager.entries.filter {
            FavoritesManager.shared.categories(for: $0.quote).contains {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }

        return Array(Set(matchesText + matchesCategory))
    }

    private func groupEntries(_ entries: [DiaryEntry]) -> [(quote: Quote, reflections: [Reflection], quoteIdentifier: String)] {
        var seen = Set<String>()
        var result: [(Quote, [Reflection], String)] = []

        for entry in entries {
            let key = entry.quote.quote + entry.quote.author
            if let index = result.firstIndex(where: { $0.2 == key }) {
                result[index].1.append(contentsOf: entry.reflections)
            } else if !seen.contains(key) {
                result.append((entry.quote, entry.reflections, key))
                seen.insert(key)
            }
        }

        return result.map { (quote, reflections, id) in
            (quote: quote, reflections: reflections.sorted(by: { $0.date > $1.date }), quoteIdentifier: id)
        }
        .sorted { $0.quote.quote < $1.quote.quote }
    }

    var body: some View {
        TabView {
            newReflectionTab
            reflectionsTab
        }
        .accentColor(.blue)
    }
    
    private var newReflectionTab: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Quote Selection
                    Text("Choose a favorite quote:")
                        .font(.system(.title3, design: .rounded).bold())
                        .foregroundColor(.primary)

                    quotePickerView
                    
                    // Reflection Input
                    Text("What does this quote mean to you?")
                        .font(.system(.title3, design: .rounded).bold())
                        .foregroundColor(.primary)

                    TextEditor(text: $reflectionText)
                        .frame(height: 200)
                        .padding(8)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(radius: 2)

                    // Save Button
                    Button(action: saveReflection) {
                        Text("Save Reflection")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(currentQuote == nil || reflectionText.trimmingCharacters(in: .whitespaces).isEmpty ?
                                Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .font(.system(.body, design: .rounded).bold())
                    }
                    .disabled(currentQuote == nil || reflectionText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("New Reflection")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .tabItem {
            Label("New Reflection", systemImage: "square.and.pencil")
        }
    }
    
    private var reflectionsTab: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                List {
                    ForEach(groupEntries(filteredEntries()), id: \.quoteIdentifier) { group in
                        NavigationLink(
                            destination: DiaryDetailView(
                                entryID: group.quote.id,
                                quote: group.quote
                            )
                        ) {
                            QuoteCardView(quote: group.quote, reflectionCount: group.reflections.count)
                        }
                        .listRowBackground(Color(.systemBackground))
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Reflections")
                .overlay {
                    if groupEntries(filteredEntries()).isEmpty {
                        emptyStateView
                    }
                }
            }
        }
        .tabItem {
            Label("Reflections", systemImage: "book")
        }
    }
    
    private var quotePickerView: some View {
        Menu {
            if FavoritesManager.shared.favorites.isEmpty {
                Text("No favorite quotes available")
                    .foregroundColor(.gray)
            } else {
                ForEach(FavoritesManager.shared.favorites, id: \.self) { quote in
                    Button(action: { currentQuote = quote }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("“\(quote.quote)”")
                                .font(.system(.body, design: .rounded))
                            Text("— \(quote.author)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let selected = currentQuote {
                        Text("“\(selected.quote)”")
                            .font(.system(.body, design: .rounded))
                            .lineLimit(2)
                        Text("— \(selected.author)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    } else {
                        Text("Select a quote")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
            .shadow(radius: 2)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text(searchText.isEmpty ? "No reflections yet" : "No matching reflections")
                .font(.system(.title3, design: .rounded).bold())
            Text("Add a new reflection to get started")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func saveReflection() {
        guard let quote = currentQuote, !reflectionText.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please select a quote and enter a reflection."
            showingAlert = true
            return
        }
        
        diaryManager.addEntry(quote: quote, reflection: reflectionText)
        alertMessage = "Reflection saved successfully!"
        showingAlert = true
        reflectionText = ""
        currentQuote = nil
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search reflections...", text: $text)
                .font(.system(.body, design: .rounded))
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct QuoteCardView: View {
    let quote: Quote
    let reflectionCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("“\(quote.quote)”")
                .font(.system(.body, design: .rounded))
                .lineLimit(2)
            Text("— \(quote.author)")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            Text("\(reflectionCount) reflection\(reflectionCount == 1 ? "" : "s")")
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}

extension Array {
    func removingDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            guard !seen.contains(element[keyPath: keyPath]) else { return false }
            seen.insert(element[keyPath: keyPath])
            return true
        }
    }
}
