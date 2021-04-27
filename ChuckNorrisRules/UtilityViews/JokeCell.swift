//
//  JokeCell.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 27/04/2021.
//

import SwiftUI

struct JokeCell: View {
    let joke: Joke
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Joke: \(joke.id)")
                .foregroundColor(Color.darkGray)
                .font(.headline)
            Text("\(joke.text)")
                .foregroundColor(Color.mediumGray)
                .font(.callout)
        }
    }
}
