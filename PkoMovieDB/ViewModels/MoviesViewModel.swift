//
//  MoviesViewModel.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 11/09/2024.
//

import Foundation
import Combine
import SwiftUI

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var searchResults: [Movie] = []
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @AppStorage("favoriteMovieIDs") private var favoriteMovieIDsData: Data = Data()

    private var cancellables = Set<AnyCancellable>()
    private let movieService = MovieService()

    var favoriteMovieIDs: Set<Int> {
        get {
            if let ids = try? JSONDecoder().decode(Set<Int>.self, from: favoriteMovieIDsData) {
                return ids
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                favoriteMovieIDsData = data
            }
        }
    }

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
    // MARK: Fetch movie
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
    // MARK: Search movie
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
    // MARK: Filter movies
    private func applyFilter(to movies: [Movie], query: String) {
        let filtered = movies.filter { movie in
            movie.title.range(of: query, options: .caseInsensitive) != nil
        }
        self.searchResults = Array(filtered.prefix(3))
    }
    // MARK: Add/remove favorites
    func toggleFavorite(for movie: Movie) {
        if favoriteMovieIDs.contains(movie.id) {
            favoriteMovieIDs.remove(movie.id)
        } else {
            favoriteMovieIDs.insert(movie.id)
        }
    }

    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovieIDs.contains(movie.id)
    }
}
