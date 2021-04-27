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
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.darkGray, Color.gray]), startPoint: .top, endPoint: .bottom)
                VStack {
                    Spacer()
                    Text("Time to laugh").foregroundColor(.white).font(.largeTitle)
                    Text("Cos' Chuck said so").foregroundColor(.white).font(.headline)
                    Image("Chuck-Norris-featured-Image")
                    Spacer()
                    NavigationLink(destination: JokesView(store: store)) {
                        StandardButton(title: "Why so serious?", color: .darkGray)
                    }
                    NavigationLink(destination: FavoritesView(store: store)) {
                        StandardButton(title: "Favourites", color: .darkGray)
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: .init()))
    }
}

