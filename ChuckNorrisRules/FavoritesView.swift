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
        List(store.state.favorites) { joke in
            Text(joke.text)
        }.navigationTitle("Favorites")
    }
}
