//
//  MoviesListView.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 13/09/2024.
//

import SwiftUI

struct MoviesListView: View {
    @StateObject var viewModel = MoviesViewModel()
    @State private var isSearchVisible: Bool = false  // State to manage search bar visibility

    var body: some View {
        NavigationView {
            VStack {
                if isSearchVisible {
                    SearchBar(text: $viewModel.searchText, onSearch: {
                        viewModel.searchMovies(query: viewModel.searchText)
                    })
                }
                List {
                    ForEach(viewModel.filteredMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            Text(movie.title)
                        }
                    }
                }
                .navigationBarTitle("Teraz grane:")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isSearchVisible.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }
}

struct SearchBar: View {
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
