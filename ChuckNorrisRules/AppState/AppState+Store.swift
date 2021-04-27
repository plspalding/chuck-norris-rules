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
    func reducer(state: inout AppState, action: AppAction) -> [Effect<AppAction>] {
        switch action {
        
        case .refreshTapped(let quanity, let categories):
            return [load(), fetch(quantity: quanity, categories: categories)]
        
        case .addToFavorites(let joke):
            set(\.favorites, on: &state, to: state.favorites + [joke])
            return []
        
        case .removeFromFavorites(let joke):
            let removed = state.favorites.filter { $0 != joke }
            set(\.favorites, on: &state, to: removed)
            return []
            
        case .removeFromFavoritesUsingIndexPath(let indexSet):
            state.favorites.remove(atOffsets: indexSet)
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
    
    private func fetch(quantity: Int, categories: [Joke.Category]) -> Effect<AppAction> {
        return { [weak self] action in
            guard let self = self else { return }
            self.Current.chuckNorrisClient.fetch(endPoint: .randomJokes(quantity: quantity, excludeCategories: categories)).sink(
                receiveCompletion: {
                    switch $0 {
                    case .failure(_): action(.networkError)
                    case .finished: break
                    }
                },
                receiveValue: {
                    action(.requestFinished($0))
                }
            ).store(in: &self.cancellables)
        }
    }
}
