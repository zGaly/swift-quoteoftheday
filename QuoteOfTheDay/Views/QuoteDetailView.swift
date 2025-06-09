//
// QuoteDetailView.Swift
// QuoteOfTheDay
//
// Created by José Luós on 26/05/2025.
//

import SwiftUI

struct QuoteDetailView: View {
    let quote: Quote
    @State private var personalNote: String = ""
    @AppStorage("quoteNotes") private var savedNotesData: Data = Data()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("“\(quote.quote)”")
                .font(.title3)
                .italic()
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Your Note:")
                .font(.headline)

            withAnimation {
                TextEditor(text: $personalNote)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut, value: personalNote)
            }

            withAnimation {
                Button("Save Note") {
                    withAnimation {
                        saveNote()
                    }
                }
                .padding(.top)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut, value: personalNote)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Quote Details")
        .onAppear {
            loadNote()
        }
    }

    private func noteKey() -> String {
        return "\(quote.quote)_\(quote.author)"
    }

    private func loadNote() {
        if let allNotes = try? JSONDecoder().decode([String: String].self, from: savedNotesData) {
            personalNote = allNotes[noteKey()] ?? ""
        }
    }

    private func saveNote() {
        var allNotes = (try? JSONDecoder().decode([String: String].self, from: savedNotesData)) ?? [:]
        allNotes[noteKey()] = personalNote
        if let encoded = try? JSONEncoder().encode(allNotes) {
            savedNotesData = encoded
        }
    }
}
