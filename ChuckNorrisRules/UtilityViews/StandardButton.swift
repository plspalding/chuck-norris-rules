//
//  StandardButton.swift
//  ChuckNorrisRules
//
//  Created by Preston Spalding on 27/04/2021.
//

import SwiftUI

struct StandardButton: View {
    private let title: String
    private let color: Color
    
    init(title: String, color: Color = .blue) {
        self.title = title
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .padding(10)
            .background(color)
            .foregroundColor(Color.white)
            .cornerRadius(10)
    }
}
