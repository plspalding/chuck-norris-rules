//
//  AppAction.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

import Foundation

enum AppAction {
    case refreshTapped(Int, [Joke.Category])
    case loading
    case networkError
    case addToFavorites(Joke)
    case removeFromFavorites(Joke)
    case removeFromFavoritesUsingIndexPath(IndexSet)
    case requestFinished([Joke])
}
