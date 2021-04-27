//
//  ChuckNorrisClient.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//

import Foundation
import Combine

protocol ChuckNorrisClientProtocol {
    func fetch(endPoint: Endpoint) -> AnyPublisher<[Joke], Error>
}

enum Endpoint {
    case randomJokes(numberOfJokes: Int, excludeCategories: [Joke.Category])
}

final class ChuckNorrisClient: ChuckNorrisClientProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://api.icndb.com"
}

extension ChuckNorrisClient {
    
    func fetch(endPoint: Endpoint) -> AnyPublisher<[Joke], Error> {
        
        switch endPoint {
        case .randomJokes:

            return NetworkAPI.fetch(
                url: URL(string: baseURL + endPoint.components.string!)!,
                decodeAs: [Joke].self
            ).map { $0.map(replaceQuotes(in:)) }
            .eraseToAnyPublisher()
        }
    }
}

extension Endpoint {
    var path: String {
        switch self {
        case .randomJokes:
            return "/jokes/random"
        }
    }
}

extension Endpoint {
    var components: URLComponents {
        switch self {
        case let .randomJokes(numberOfJokes, exclude):
            var comp = URLComponents(string: path + "/\(numberOfJokes)")!
            comp.queryItems = [
                URLQueryItem(name: "exclude", value: "[" + exclude.joined(separator: ",") + "]")
            ]
            return comp
        }
    }
}
