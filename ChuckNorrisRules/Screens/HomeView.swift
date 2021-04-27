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
                        Text("Why so serious?")
                                    .padding(10)
                                    .background(Color.green)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                    }
                    NavigationLink(destination: FavoritesView(store: store)) {
                        Text("Favourites")
                            .padding(10)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: .init()))
    }
}

