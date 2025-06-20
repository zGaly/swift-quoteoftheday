//
//  DiaryDetailView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 28/05/2025.
//

import SwiftUI

struct DiaryDetailView: View {
    let entryID: UUID
    let quote: Quote

    @State private var editingReflectionIDs: Set<UUID> = []
    @Environment(\.dismiss) private var dismiss
    @State private var reflections: [Reflection] = []

    private func loadReflections() {
        reflections = DiaryManager.shared.getReflections(for: quote)
    }

    private func delete(reflectionID: UUID) {
        if let entry = DiaryManager.shared.entries.first(where: { $0.quote.quote == quote.quote && $0.quote.author == quote.author }) {
            DiaryManager.shared.deleteReflection(entryID: entry.id, reflectionID: reflectionID)
        }
        withAnimation {
            loadReflections()
            if reflections.isEmpty {
                dismiss()
            }
        }
    }

    private func update(reflectionID: UUID, newText: String) {
        if let entry = DiaryManager.shared.entries.first(where: { $0.quote.quote == quote.quote && $0.quote.author == quote.author }) {
            DiaryManager.shared.updateReflection(entryID: entry.id, reflectionID: reflectionID, newText: newText)
        }
        withAnimation {
            reflections = DiaryManager.shared.getReflections(for: quote)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("“\(quote.quote)”")
                    .font(.title2)
                    .padding(.bottom, 4)

                Text("Quote by \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Divider()

                ForEach(reflections.sorted(by: { $0.date > $1.date }), id: \.id) { reflection in
                    VStack(alignment: .leading, spacing: 8) {
                        if editingReflectionIDs.contains(reflection.id) {
                            TextEditor(text: Binding(
                                get: {
                                    reflection.text
                                },
                                set: { newText in
                                    update(reflectionID: reflection.id, newText: newText)
                                }
                            ))
                            .frame(minHeight: 80)
                            .padding(4)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        editingReflectionIDs.remove(reflection.id)
                                        hideKeyboard()
                                    }
                                }
                            }
                        } else {
                            Text(reflection.text)
                                .padding(4)
                        }

                        Text(reflection.date.formatted(date: .long, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)

                        HStack {
                            Spacer()
                            Button(role: .destructive) {
                                delete(reflectionID: reflection.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .font(.caption)
                            }

                            Button {
                                withAnimation {
                                    if editingReflectionIDs.contains(reflection.id) {
                                        editingReflectionIDs.remove(reflection.id)
                                    } else {
                                        editingReflectionIDs.insert(reflection.id)
                                    }
                                }
                            } label: {
                                Label(editingReflectionIDs.contains(reflection.id) ? "Save" : "Edit", systemImage: editingReflectionIDs.contains(reflection.id) ? "checkmark" : "pencil")
                                    .font(.caption)
                            }
                        }

                        Divider()
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: loadReflections)
        .navigationTitle("Reflections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
