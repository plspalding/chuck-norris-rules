//
//  ErrorView.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 27/04/2021.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        Text("An Error has occured.\nPlease try refreshing the page")
            .multilineTextAlignment(.center)
            .foregroundColor(Color.mediumGray)
            .font(.callout)
    }
}
