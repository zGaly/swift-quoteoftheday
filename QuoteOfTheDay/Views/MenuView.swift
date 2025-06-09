//
//  MenuView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            NavigationLink(destination: FavoritesView()) {
                Label("Favorites", systemImage: "heart.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            NavigationLink(destination: DiaryView()) {
                Label("Diary", systemImage: "book")
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Button(action: {
                withAnimation {
                    showMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.gray)
                    Text("Dark Mode")
                }
                .font(.headline)
                .foregroundColor(.primary)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 6)
    }
}
