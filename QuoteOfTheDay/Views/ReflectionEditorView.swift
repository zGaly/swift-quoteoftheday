//
//  ReflectionEditorView.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 29/05/2025.
//

import SwiftUI

struct ReflectionEditorView: View {
    let reflection: Reflection
    let onSave: (String) -> Void
    let onDelete: () -> Void

    @State private var editedText: String
    @State private var isEditing: Bool = false

    init(reflection: Reflection, onSave: @escaping (String) -> Void, onDelete: @escaping () -> Void) {
        self.reflection = reflection
        self.onSave = onSave
        self.onDelete = onDelete
        _editedText = State(initialValue: reflection.text)
    }

    private func handleEditOrSave() {
        if isEditing {
            onSave(editedText)
        }
        isEditing.toggle()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if isEditing {
                    TextEditor(text: $editedText)
                        .frame(minHeight: 80)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
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
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .font(.caption)
                    }

                    Button(action: handleEditOrSave) {
                        Label(isEditing ? "Save" : "Edit", systemImage: isEditing ? "checkmark" : "pencil")
                            .font(.caption)
                    }
                }

                Divider()
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .padding()
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
