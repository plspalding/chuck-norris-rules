//
//  FavoritesView.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        List {
            ForEach(store.state.favorites) {
                JokeCell(joke: $0)
            }.onDelete(perform: { store.send(.removeFromFavoritesUsingIndexPath($0)) })
        }
        .navigationTitle("Favorites")
    }
}
