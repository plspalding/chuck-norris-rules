//
//  StoreTests.swift
//  ChuckNorrisRulesTests
//
//  Created by Preston Spalding on 25/04/2021.
//

import XCTest
import Combine
@testable import ChuckNorrisRules

final class StoreTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    private var store: Store<AppState> = .init(initialState: .init())
    
    override func setUp() {
        store = initialState
    }
    
    override func tearDown() {
        store = initialState
    }
    
    func test_initialStateOfApp_isInNotRequestedState() {
        store.$state.sink(
            receiveCompletion: assertFailed,
            receiveValue: {
                XCTAssertEqual($0.requestState, .notRequested)
            })
        .store(in: &cancellables)
    }
    
    func test_requestStateIsLoading_afterLoadingAction() {
        store.send(.loading)
        store.$state.sink(
            receiveCompletion: assertFailed,
            receiveValue: {
                XCTAssertEqual($0.requestState, .loading)
            })
        .store(in: &cancellables)
    }
    
    func test_requestStateReceivedLoadingFollowedBySuccess_afterRefreshTappedAction() {
        // TODO: Need to inject dummy network layer into Store so that the fetch returns data I am expecting.
        let expected = ExpectedValues<RequestState<Joke>>(
            inOrder: .loading, .success([])
        )
        store.send(.refreshTapped)
        let exp = expectation(description: "Should enter loading state followed by success state")
        store.$state.sink(
            receiveCompletion: assertFailed,
            receiveValue: {
                expected.run(with: $0.requestState) {
                    exp.fulfill()
                }
            }).store(in: &cancellables)
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_addToFavoritesArrayContainsJoke_whenAddToFavoritesIsSent() {
        let joke = Joke.init(id: 0, text: "Chuck Norris")
        store.send(.addToFavorites(joke))
        store.$state.sink {
            XCTAssertTrue($0.favorites.contains(joke))
        }.store(in: &cancellables)
    }
    
    func test_addToFavoritesArrayContainsJokes_whenAddToFavoritesIsSent() {
        let j1 = Joke.init(id: 0, text: "Chuck Norris")
        let j2 = Joke(id: 1, text: "Chuck Norris jokes again")
        store.send(.addToFavorites(j1))
        store.send(.addToFavorites(j2))
        store.$state.sink {
            XCTAssertTrue($0.favorites.contains(j1))
            XCTAssertTrue($0.favorites.contains(j2))
        }.store(in: &cancellables)
    }
    
    func test_removeJoke_whenRemoveFromFavoritesIsSent() {
        let j1 = Joke.init(id: 0, text: "Chuck Norris")
        let j2 = Joke(id: 1, text: "Chuck Norris jokes again")
        store.send(.addToFavorites(j1))
        store.send(.addToFavorites(j2))
        store.send(.removeFromFavorites(j1))
        store.$state.sink {
            XCTAssertFalse($0.favorites.contains(j1))
            XCTAssertTrue($0.favorites.contains(j2))
        }.store(in: &cancellables)
    }
}

class ExpectedValues<Value: Equatable> {
    var count = 0
    var expectedValueCount: Int
    let values: [Value]
    init(inOrder values: Value...) {
        self.values = values
        self.expectedValueCount = values.count
    }
    
    func run(with value: Value, completion: () -> ()) {
        XCTAssertEqual(values[count], value)
        count += 1
        if count == expectedValueCount {
            completion()
        }
    }
}

// Helpers
var initialState: Store<AppState> = Store<AppState>.init(initialState: .init())

var assertFailed: (Any) -> () {
    { _ in XCTFail() }
}
