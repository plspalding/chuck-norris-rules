//
//  HomeView.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//

import SwiftUI

struct HomeView: View {
        
    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: JokesView(store: store)) {
                    Text("Why so serious?")
                }
                NavigationLink(destination: FavoritesView(store: store)) {
                    Text("Favs")
                }
            }
        }
    }
}
