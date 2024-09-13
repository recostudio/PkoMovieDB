//
//  MoviesViewModel.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 11/09/2024.
//

import SwiftUI
import Combine

struct MoviesListView: View {
    @StateObject var viewModel = MoviesViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        Text(movie.title)
                    }
                }
            }
            .navigationBarTitle("Teraz grane:")
        }
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""

    private var cancellable: AnyCancellable?
    private let movieService = MovieService()

    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    func fetchMovies() {
        cancellable = movieService.fetchNowPlayingMovies()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { movies in
                self.movies = movies
            })
    }
}
