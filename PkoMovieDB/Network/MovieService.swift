//
//  MovieService.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 11/09/2024.
//

import Foundation
import Combine

class MovieService {
    private let apiKey = "YOUR_API_KEY"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(baseURL)/movie/now_playing")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "pl-PL"),
            URLQueryItem(name: "page", value: "1"),
        ]

        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
