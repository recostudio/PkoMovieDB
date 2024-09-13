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
    @Published var searchText: String = "" {
        didSet {
            searchMovies(query: searchText)
        }
    }
    @Published var searchResults: [Movie] = []
    @Published var isSearching: Bool = false

    private var cancellable: AnyCancellable?
    private let movieService = MovieService()

    var filteredMovies: [Movie] {
        if isSearching && !searchText.isEmpty {
            return searchResults
        } else {
            return movies
        }
    }

    func fetchMovies() {
        cancellable = movieService.fetchNowPlayingMovies()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { movies in
                      self.movies = movies
                  })
    }

    func searchMovies(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        cancellable = movieService.searchMovies(query: query)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                      self.applyRegexFilter(to: movies, query: query)
                  })
    }

    private func applyRegexFilter(to movies: [Movie], query: String) {
        do {
            let regex = try NSRegularExpression(pattern: query, options: .caseInsensitive)
            let filtered = movies.filter { movie in
                let range = NSRange(location: 0, length: movie.title.utf16.count)
                return regex.firstMatch(in: movie.title, options: [], range: range) != nil
            }
            self.searchResults = Array(filtered.prefix(3))
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            self.searchResults = []
        }
    }
}
