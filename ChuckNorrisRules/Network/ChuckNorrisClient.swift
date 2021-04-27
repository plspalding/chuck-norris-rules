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
        guard let path = endPoint.components.string, let url = URL(string: baseURL + path) else {
            fatalError("Badly formed url request")
        }
        return NetworkAPI.fetch(
            url: url,
            decodeAs: [Joke].self
        ).map { $0.map(replaceQuotes(in:)) }
        .eraseToAnyPublisher()
    }
}

private extension Endpoint {
    var path: String {
        switch self {
        case .randomJokes:
            return "/jokes/random"
        }
    }
}

private extension Endpoint {
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
