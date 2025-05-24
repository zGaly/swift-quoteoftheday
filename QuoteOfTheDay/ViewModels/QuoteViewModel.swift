//
//  QuoteViewModel.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import Foundation
import SwiftUI

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var quote: Quote?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var category: String = "life"

    private let service = QuoteService()

    func fetchQuote() {
        isLoading = true
        errorMessage = nil
        quote = nil

        Task {
            do {
                let result = try await fetchAsync(category: category)
                self.quote = result
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    private func fetchAsync(category: String) async throws -> Quote {
        return try await withCheckedThrowingContinuation { continuation in
            service.fetchQuote(category: category, completion: { result in
                switch result {
                case .success(let quote):
                    continuation.resume(returning: quote)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
