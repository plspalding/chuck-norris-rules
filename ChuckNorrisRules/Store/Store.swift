//
//  Model.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//


import Foundation
import Combine

typealias Effect<Action> = (@escaping (Action) -> Void) -> Void

final class Store<State>: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var state: State
    private(set) var Current: Env
    
    init(initialState: State, env: Env = Env()) {
        self.state = initialState
        self.Current = env
    }
}

extension Store where State == AppState {
    
    func send(_ action: AppAction) {
        let effects = reducer(state: &state, action: action)
        effects.forEach {
            print("Debug: Perform effect")
            $0 { action in self.send(action) }
        }
    }
}

func set<Value>(
    _ kp:  WritableKeyPath<AppState, Value>,
    on state: inout AppState,
    to value: Value) {
    state[keyPath: kp] = value
}
