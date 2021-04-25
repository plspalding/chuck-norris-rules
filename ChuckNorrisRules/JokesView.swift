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
        case .notRequested: ProgressView().onAppear {
            store.send(.refreshTapped)
        }
        case .loading: ProgressView().onAppear { store.send(.refreshTapped) }
        case .success(let jokes):
            List(jokes) { joke in
                Button(action: { showModal.toggle() }) {
                    if store.state.favorites.contains(joke) {
                        Text("\(joke.text)").background(Color.gray)
                    } else {
                        Text("\(joke.text)")
                    }
                }.sheet(isPresented: $showModal) {
                    AddToFavoritesView(joke: joke, store: store)
                }
            }
            .asNavigation(store: store, showOptions: $showOptions)
        case .error: Text("An Error has occured. Please try refreshing the page")
            .asNavigation(store: store, showOptions: $showOptions)
        }
    }
}

extension View {
    func asNavigation(store: Store<AppState>, showOptions: Binding<Bool>) -> some View {
        return self
            .navigationTitle("Chuck Norris Jokes")
            .toolbar {
                HStack {
                    Button("Refresh") {
                        store.send(.refreshTapped)
                    }
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



