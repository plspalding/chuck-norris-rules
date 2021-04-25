//
//  RequestState.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 25/04/2021.
//

enum RequestState<Value>: Equatable where Value: Equatable {
    static func == (lhs: RequestState<Value>, rhs: RequestState<Value>) -> Bool {
        switch (lhs, rhs)  {
        case (.notRequested, .notRequested),
             (.loading, .loading),
             (.error, .error): return true
        case let (.success(v1), .success(v2)): return v1 == v2
        case (_,_): return false
            
        }
    }
    
    case notRequested
    case loading
    case success([Value])
    case error
}
