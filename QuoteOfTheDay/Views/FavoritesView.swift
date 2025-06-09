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
    @State private var showRenamePrompt = false
    @State private var categoryToRename: String?

    var body: some View {
        NavigationStack {
            List {
                if favoritesManager.favoritesByCategory.isEmpty {
                    Text("No favorites yet.")
                        .foregroundStyle(.secondary)
                } else {
                    let favoriteKey = favoritesManager.favoritesByCategory.keys.first { $0.lowercased() == "favorites" }
                    let sortedCategories = (favoriteKey != nil ? [favoriteKey!] : []) +
                        favoritesManager.favoritesByCategory.keys
                            .filter { $0.lowercased() != "favorites" }
                            .sorted(by: { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending })

                    ForEach(sortedCategories, id: \.self) { category in
                        if let quotes = favoritesManager.favoritesByCategory[category] {
                            Section(header:
                                HStack {
                                    Text(category.capitalized)
                                        .font(.headline)
                                    Spacer()
                                    if category.lowercased() != "favorites" {
                                        Button {
                                            categoryToRename = category
                                            newCategoryName = category
                                            showRenamePrompt = true
                                        } label: {
                                            Image(systemName: "pencil")
                                        }

                                        Button(role: .destructive) {
                                            withAnimation {
                                                favoritesManager.removeCategory(category)
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                    }
                                }
                            ) {
                                ForEach(quotes.reversed()) { quote in
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
                                                ForEach(
                                                    favoritesManager.favoritesByCategory.keys.sorted().filter {
                                                        !favoritesManager.categories(for: quote).contains($0)
                                                    },
                                                    id: \.self
                                                ) { category in
                                                    Button("Move to \(category)") {
                                                        withAnimation {
                                                            favoritesManager.move(quote, to: category)
                                                        }
                                                    }
                                                }

                                                Button("New Category") {
                                                    withAnimation {
                                                        showingCategoryPrompt = quote
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "plus.circle")
                                                    .imageScale(.large)
                                            }
                                        }
                                    }
                                }
                                .onDelete { offsets in
                                    withAnimation {
                                        favoritesManager.remove(at: offsets, in: category)
                                    }
                                }
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
                    if let quote = showingCategoryPrompt, !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        withAnimation {
                            favoritesManager.add(quote, to: newCategoryName)
                        }
                        newCategoryName = ""
                        showingCategoryPrompt = nil
                    }
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Button("Cancel", role: .cancel) {
                    showingCategoryPrompt = nil
                    newCategoryName = ""
                }
            } message: {
                Text("Enter a name for the new category.")
            }
            .alert("Rename Category", isPresented: $showRenamePrompt) {
                TextField("New name", text: $newCategoryName)
                Button("Save") {
                    if let old = categoryToRename,
                       !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        withAnimation {
                            favoritesManager.renameCategory(old, to: newCategoryName)
                        }
                    }
                    showRenamePrompt = false
                    newCategoryName = ""
                    categoryToRename = nil
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Button("Cancel", role: .cancel) {
                    showRenamePrompt = false
                    newCategoryName = ""
                    categoryToRename = nil
                }
            } message: {
                Text("Enter the new name for this category.")
            }
        }
    }
}
