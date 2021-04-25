//
//  AppAction.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

enum AppAction {
    case refreshTapped
    case loading
    case networkError
    case addToFavorites(Joke)
    case removeFromFavorites(Joke)
    case requestFinished([Joke])
}
