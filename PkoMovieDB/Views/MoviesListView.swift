//
//  MoviesListView.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 13/09/2024.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @State private var isSearchVisible: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if isSearchVisible {
                    SearchBarView(text: $viewModel.searchText, suggestions: viewModel.searchResults)
                }
                if viewModel.isLoading {
                    ProgressView("Wczytywanie informacji o filmach...")
                } else if viewModel.filteredMovies.isEmpty {
                    Text("Brak filmów do wyświetlenia.")
                        .foregroundColor(.gray)
                    Text("Sprawdź czy wprowadziłeś swój API Key :)")
                    Text("Wiem, ładniej byłoby przechować np. Info.plist")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.filteredMovies) { movie in
                            HStack {
                                Button(action: {
                                    viewModel.toggleFavorite(for: movie)
                                }) {
                                    Image(systemName: viewModel.isFavorite(movie: movie) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                                    Text(movie.title)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Teraz grane:")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                withAnimation {
                                    isSearchVisible.toggle()
                                    viewModel.isSearching = isSearchVisible
                                    if !isSearchVisible {
                                        viewModel.searchText = ""
                                    }
                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                            }
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
