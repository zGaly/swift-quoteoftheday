//
//  QuoteService.swift
//  QuoteOfTheDay
//
//  Created by José Luís on 24/05/2025.
//

import Foundation

struct QuoteService {
    func fetchQuote(category: String, completion: @escaping (Result<Quote, Error>) -> Void) {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/quotes") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(SecretsManager.shared.apiKey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let quote = quotes.first {
                    completion(.success(quote))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
