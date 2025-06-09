//
// QuoteView.swift
// QuoteOfTheDay
//
// Created by José Luís on 26/05/2025.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @ObservedObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            if viewModel.isLoading {
                withAnimation {
                    ProgressView("Loading...")
                }
            } else if let quote = viewModel.quote {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                toggleFavorite(quote)
                            }
                        }) {
                            Image(systemName: favoritesManager.contains(quote) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesManager.contains(quote) ? .red : .gray)
                                .imageScale(.large)
                        }
                    }

                    Text("“\(quote.quote)”")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()

                    Text("- \(quote.author)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 5)
                )
                .padding()
                .transition(.opacity.combined(with: .slide))
            } else if let error = viewModel.errorMessage {
                Text("⚠️ \(error)")
                    .foregroundColor(.red)
            }

            Spacer()

            Button("New Quote") {
                withAnimation {
                    viewModel.fetchQuote()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchQuote()
        }
    }

    private func toggleFavorite(_ quote: Quote) {
        withAnimation {
            if favoritesManager.contains(quote) {
                favoritesManager.remove(quote)
            } else {
                favoritesManager.add(quote, to: "favorites")
            }
        }
    }
}
