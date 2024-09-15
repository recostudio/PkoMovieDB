//
//  MoviesViewModel.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 11/09/2024.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var searchResults: [Movie] = []
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let movieService = MovieService()

    var filteredMovies: [Movie] {
        if isSearching && !searchText.isEmpty {
            return searchResults
        } else {
            return movies
        }
    }

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }

    func fetchMovies() {
        self.isLoading = true
        movieService.fetchNowPlayingMovies()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }

    func searchMovies(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        movieService.searchMovies(query: query)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] movies in
                self?.applyFilter(to: movies, query: query)
            })
            .store(in: &cancellables)
    }

    private func applyFilter(to movies: [Movie], query: String) {
        let filtered = movies.filter { movie in
            movie.title.range(of: query, options: .caseInsensitive) != nil
        }
        self.searchResults = Array(filtered.prefix(3))
    }
}
