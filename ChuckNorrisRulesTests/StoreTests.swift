//
//  StoreTests.swift
//  ChuckNorrisRulesTests
//
//  Created by Preston Spalding on 25/04/2021.
//

import XCTest
import Combine
@testable import ChuckNorrisRules

class MockChuckNorrisClient: ChuckNorrisClientProtocol {
    
    var result: Result<[Joke], Error>
    
    init(response: Result<[Joke], Error> = .success([])) {
        self.result = response
    }
    
    func fetch(endPoint: Endpoint) -> AnyPublisher<[Joke], Error> {
        switch result {
        case .success(let joke):
            return Just(joke).setFailureType(to: Error.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

final class StoreTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    private var store: Store<AppState>!
    
    override func setUp() {
        store = mock(result: .success([]))
    }
    
    override func tearDown() {
        store = nil
    }
    
    func test_initialStateOfApp_isInNotRequestedState() {
        store.$state.sink(
            receiveCompletion: assertFailed,
            receiveValue: {
                XCTAssertEqual($0.requestState, .notRequested)
            })
        .store(in: &cancellables)
    }
    
    func test_requestStateReceivedLoadingFollowedBySuccess_afterRefreshTappedAction() {
        let expected = ExpectedValues<RequestState<Joke>>(
            inOrder: .notRequested, .notRequested, .loading, .success([])
        )
        let exp = expectation(description: "Should enter loading state followed by success state")
        store.$state.sink(
            receiveCompletion: assertFailed,
            receiveValue: {
                print("Debug: \($0)")
                expected.run(with: $0.requestState) {
                    exp.fulfill()
                }
            }).store(in: &cancellables)
        store.send(.refreshTapped(-1, []))
        wait(for: [exp], timeout: 0.2)
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
    
    func test_removeJoke_whenRemoveFromFavoritesUsingIndexSetSent() {
        let j1 = Joke.init(id: 0, text: "Chuck Norris")
        let j2 = Joke(id: 1, text: "Chuck Norris jokes again")
        store.send(.addToFavorites(j1))
        store.send(.addToFavorites(j2))
        store.send(.removeFromFavoritesUsingIndexPath(.init(arrayLiteral: 0)))
        store.$state.sink {
            XCTAssertFalse($0.favorites.contains(j1))
            XCTAssertTrue($0.favorites.contains(j2))
        }.store(in: &cancellables)
    }
    
    func test_errorRecevied_whenErrorReturnedFromServer() {
        enum TestError: Error { case test }
        let store = mock(result: .failure(TestError.test))
        store.send(.refreshTapped(-1, []))
        store.$state.sink {
            XCTAssertEqual($0.requestState, .error)
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
var assertFailed: (Any) -> () {
    { _ in XCTFail() }
}

func mock(result: Result<[Joke], Error>) -> Store<AppState> {
    let chuckNorrisClient = MockChuckNorrisClient(response: result)
    return Store(
        initialState: AppState(jokes: [], fetchQuantity: 0, favorites: [], requestState: .notRequested),
        env: Env(chuckNorrisClient: chuckNorrisClient)
    )
}
