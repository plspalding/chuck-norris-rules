//
//  ContentView.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 23/04/2021.
//

import SwiftUI
import Combine

struct JokesView: View {
    
    @ObservedObject var store: Store<AppState>
    @State var showModal = false
    @State var showOptions = false
    
    var body: some View {
        switch store.state.requestState {
        case .notRequested: ProgressView().onAppear { store.send(.refreshTapped(10, [.explicit])) }
        case .loading: ProgressView()
        case .success(let jokes):
            List(jokes) { joke in
                if store.state.favorites.contains(joke) {
                    HStack {
                        JokeCell(joke: joke)
                        Spacer()
                        Image(systemName: "hand.thumbsup.fill")
                        
                    }.onTapGesture { store.send(.removeFromFavorites(joke)) }
                } else {
                    JokeCell(joke: joke).onTapGesture { store.send(.addToFavorites(joke)) }
                }
            }
            .withNavigation(store: store, showOptions: $showOptions)
        case .error: ErrorView()
            .withNavigation(store: store, showOptions: $showOptions)
        }
    }
}

extension View {
    func withNavigation(
        store: Store<AppState>,
        showOptions: Binding<Bool>) -> some View
    {
        return self
            .navigationTitle("Chuck Norris Jokes").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    Image(systemName: "arrow.clockwise").onTapGesture {
                        store.send(.refreshTapped(store.state.fetchQuantity, [.explicit]))
                    }
//                    Button("Refresh") {
//                    }
                    Button(action: { showOptions.wrappedValue.toggle() }) {
                        Text("Options")
                    }.sheet(isPresented: showOptions) {
                        Options()
                    }
                }
            }
    }
}

struct Options: View {
    
    var body: some View {
        Text("Options for selecting the number of jokes received and what to exclude")
    }
}

struct AddToFavoritesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var joke: Joke
    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        HStack {
            Text("Add to favaorites: ")
            if store.state.favorites.contains(where: { $0 == joke }) {
                Button("Remove") {
                    store.send(.removeFromFavorites(joke))
                    presentationMode.wrappedValue.dismiss() // TODO: Can this be moved so only called once
                }
            } else {
                Button("Add") {
                    store.send(.addToFavorites(joke))
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        JokesView(store: Store(initialState: .init()))
    }
}
