//
//  SearchBar.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 13/09/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var suggestions: [Movie]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Szukaj...", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.top)

        }
    }
}
