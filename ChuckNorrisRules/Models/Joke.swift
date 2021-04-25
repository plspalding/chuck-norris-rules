//
//  Joke.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

import Foundation

struct Joke: Decodable, Equatable, Identifiable {
    let id: Int
    let text: String
}

private extension Joke {
    enum CodingKeys: String, CodingKey {
        case id
        case text = "joke"
    }
}

enum Categories: String {
    case explicit
    case nerdy
}
