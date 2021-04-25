//
//  ChuckNorrisClient.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 24/04/2021.
//

import Foundation
import Combine

struct ChuckNorrisClient {
    private let baseURL = "https://api.icndb.com"
    private let endpoint = "jokes/random/"
    private let exclude: [Categories]  = [.explicit]
    
    var url: String! {
        baseURL.appending("/").appending(endpoint)
    }
    
    func request(numberOfJokes: Int) -> URL {
        var comp = URLComponents(string: url + "/\(numberOfJokes)")!
        comp.queryItems = [
            URLQueryItem(
                name: "exclude",
                value: "[" + exclude.joined(separator: ",") + "]")
        ]
        return comp.url!
    }
}

private extension Array where Element == Categories {
    func joined(separator: String) -> String {
        var x: String = ""
        for elem in self {
            x.append(",")
            x.append(elem.rawValue)
        }
        return x
    }
}
