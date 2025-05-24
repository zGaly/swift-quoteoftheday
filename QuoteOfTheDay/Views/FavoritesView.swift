//
//  FavoritesView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared
    @State private var showingCategoryPrompt: Quote?
    @State private var newCategoryName: String = ""

    var body: some View {
        NavigationStack {
            List {
                if favoritesManager.favoritesByCategory.isEmpty {
                    Text("No favorites yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(favoritesManager.favoritesByCategory.sorted(by: { $0.key < $1.key }), id: \.key) { category, quotes in
                        Section(header: Text(category.capitalized).font(.headline)) {
                            ForEach(quotes) { quote in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("“\(quote.quote)”")
                                                .font(.body)
                                            Text("- \(quote.author)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        Menu {
                                            ForEach(favoritesManager.favoritesByCategory.keys.sorted(), id: \.self) { category in
                                                Button("Move to \(category)") {
                                                    favoritesManager.remove(quote)
                                                    favoritesManager.add(quote, to: category)
                                                }
                                            }

                                            Button("New Category") {
                                                showingCategoryPrompt = quote
                                            }
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .imageScale(.large)
                                        }
                                    }
                                }
                            }
                            .onDelete { offsets in
                                favoritesManager.remove(at: offsets, in: category)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
            .alert("New Category", isPresented: Binding<Bool>(
                get: { showingCategoryPrompt != nil },
                set: { if !$0 { showingCategoryPrompt = nil } }
            )) {
                TextField("Category name", text: $newCategoryName)
                Button("Add") {
                    if let quote = showingCategoryPrompt {
                        favoritesManager.remove(quote)
                        favoritesManager.add(quote, to: newCategoryName)
                        newCategoryName = ""
                        showingCategoryPrompt = nil
                    }
                }
                Button("Cancel", role: .cancel) {
                    showingCategoryPrompt = nil
                    newCategoryName = ""
                }
            } message: {
                Text("Enter a name for the new category.")
            }
        }
    }
}
