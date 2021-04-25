//
//  AppStore.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

import Foundation

struct AppState {
    fileprivate(set) var jokes: [Joke] = []
    fileprivate(set) var fetchQuantity: Int = 10
    fileprivate(set) var favorites: [Joke] = []
    fileprivate(set) var requestState: RequestState<Joke> = .notRequested
}

extension Store where State == AppState {
    
    func fetch(
        numberOfJokes: Int,
        excludeCategories: Categories,
        completion: @escaping (Result<[Joke], Error>) -> ())
    {
        guard numberOfJokes > 0 else { return }
        NetworkAPI.fetch(
            endpoint: ChuckNorrisClient().request(numberOfJokes: state.fetchQuantity),
            decodeAs: [Joke].self
        ).map(replaceQuotes(in:))
        .sink(
            receiveCompletion: { completed in
                switch completed {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            },
            receiveValue: {
                completion(.success($0))
            }
        )
        .store(in: &cancellables)
    }
    
    private func replaceQuotes(in jokes: [Joke]) -> [Joke] {
        jokes.map(replaceQuotes(in:))
    }
    
    private func replaceQuotes(in joke: Joke) -> Joke {
        Joke(id: joke.id, text: quoteReplacement(in: joke.text))
    }
    
    private func quoteReplacement(in string: String) -> String {
        string.replacingOccurrences(of: "&quot;", with: "\"")
    }
}

extension Store where State == AppState {
    func reducer(state: inout AppState, action: AppAction) -> [Effect<AppAction>] {
        switch action {
        
        case .refreshTapped:
            return [load(), fetch()]
        
        case .addToFavorites(let joke):
            set(\.favorites, on: &state, to: state.favorites + [joke])
            return []
        
        case .removeFromFavorites(let joke):
            let removed = state.favorites.filter { $0 != joke }
            set(\.favorites, on: &state, to: removed)
            return []
        
        case .requestFinished(let jokes):
            set(\.requestState, on: &state, to: .success(jokes))
            set(\.jokes, on: &state, to: jokes)
            return []
        
        case .loading:
            set(\.requestState, on: &state, to: .loading)
            return []
        
        case .networkError:
            set(\.requestState, on: &state, to: .error)
            return []
        }
    }
    
    private func load() -> Effect<AppAction> {
        return { action in
            action(.loading)
        }
    }
    
    private func fetch() -> Effect<AppAction> {
        return { [weak self] action in
            self?.fetch(
                numberOfJokes: self?.state.fetchQuantity ?? 10,
                excludeCategories: Categories.explicit) {
                switch $0 {
                case .success(let joke): action(.requestFinished(joke))
                case .failure(_): action(.networkError)
                }
            }
        }
    }
}
