//
//  QuoteReplacement.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 27/04/2021.
//

func replaceQuotes(in joke: Joke) -> Joke {
    Joke(id: joke.id, text: quoteReplacement(in: joke.text))
}

func quoteReplacement(in string: String) -> String {
    string.replacingOccurrences(of: "&quot;", with: "\"")
}
