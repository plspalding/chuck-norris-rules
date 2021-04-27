//
//  Joke.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

import Foundation

struct Joke: Decodable, Equatable, Identifiable {
    enum Category: String {
        case explicit
        case nerdy
    }
    
    let id: Int
    let text: String
}

private extension Joke {
    enum CodingKeys: String, CodingKey {
        case id
        case text = "joke"
    }
}

extension Array where Element == Joke.Category {
    func joined(separator: String) -> String {
        var x: String = ""
        for elem in self {
            x.append(",")
            x.append(elem.rawValue)
        }
        return x
    }
}
