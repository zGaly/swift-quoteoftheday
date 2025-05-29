//
//  MainView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import SwiftUI

struct MainView: View {
    @State private var showMenu = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme
    @State private var navigateToFavorites = false
    @State private var navigateToDiary = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                QuoteView()

                .navigationDestination(isPresented: $navigateToFavorites) {
                    FavoritesView()
                }
                .navigationDestination(isPresented: $navigateToDiary) {
                    DiaryView()
                }

                if showMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }

                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        showMenu = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.primary)
                                        .padding()
                                }
                            }

                            Button {
                                navigateToFavorites = true
                                showMenu = false
                            } label: {
                                Label("Favorites", systemImage: "heart.fill")
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 12)

                            Button {
                                isDarkMode.toggle()
                            } label: {
                                Label("Dark Mode", systemImage: "moon.fill")
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 12)

                            Button {
                                navigateToDiary = true
                                showMenu = false
                            } label: {
                                Label("Diary", systemImage: "book.fill")
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 12)

                            Spacer()
                        }
                        .frame(width: 260)
                        .background(
                            colorScheme == .dark ? Color.black.opacity(0.95) : Color.white.opacity(0.95)
                        )
                        .cornerRadius(20)
                        .shadow(radius: 6)
                        .transition(.move(edge: .leading))
                        .zIndex(2)

                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Quote")
                        .font(.headline)
                        .bold(true)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}
