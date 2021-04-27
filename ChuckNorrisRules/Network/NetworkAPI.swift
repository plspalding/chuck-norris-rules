//
//  NetworkAPI.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//

import Foundation
import Combine

struct Response<A: Decodable>: Decodable {
    let type: String
    let value: A
}

class NetworkAPI {
    
    static func fetch<A: Decodable>(
        url: URL,
        decodeAs type: A.Type) -> AnyPublisher<A, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response<A>.self, decoder: JSONDecoder())
            .map(\.value)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
