//
//  OptionsView.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 27/04/2021.
//

import SwiftUI

struct Options: View {
    
    var body: some View {
        mediumGrayTextView("Coming soon:").font(.largeTitle)
        mediumGrayTextView("1. Update number of jokes returned by request")
        mediumGrayTextView("2. Decide which Categories to exclude")
    }
    
    private func mediumGrayTextView(_ title: String) -> some View {
        Text(title).foregroundColor(Color.mediumGray)
    }
}
