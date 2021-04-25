//
//  NetworkAPI.swift
//  ChuckNorrisRulesTests
//
//  Created by Preston Spalding on 24/04/2021.
//

import XCTest
import Combine
@testable import ChuckNorrisRules

struct Test: Decodable {
    let id: Int
    let title: String
    let text: String
}

class NetworkAPITests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_x() {
        if let path = Bundle(for: type(of: self)).path(forResource: "Test", ofType: "json") {
            do {
                NetworkAPI
                    .fetch(
                        endpoint: URL(fileURLWithPath: path),
                        decodeAs: [Test].self
                    ).sink(
                    receiveCompletion: { print("Debug: \($0)") },
                    receiveValue: { print("Debug: \($0)") }).store(in: &cancellables)
              } catch {
                   print("Debug: \(error)")
              }
        }
    }
}

