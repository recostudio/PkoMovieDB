//
//  SearchBar.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 13/09/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onSubmit {
                    onSearch()
                }

            Button(action: onSearch) {
                Text("Search")
            }
            .padding(.trailing)
        }
    }
}
