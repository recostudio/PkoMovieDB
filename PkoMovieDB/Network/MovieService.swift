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
        guard var components = URLComponents(string: "\(baseURL)/movie/now_playing") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        components.queryItems = [
            URLQueryItem(name: "language", value: "pl-PL"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: RunLoop.main)
            .catch { error in
                Just([]).setFailureType(to: Error.self)
            }
            .eraseToAnyPublisher()
    }

    func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
           guard var components = URLComponents(string: "\(baseURL)/search/movie") else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }

           components.queryItems = [
               URLQueryItem(name: "query", value: query),
               URLQueryItem(name: "language", value: "pl-PL"),
               URLQueryItem(name: "page", value: "1"),
               URLQueryItem(name: "api_key", value: apiKey)
           ]

           guard let url = components.url else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.timeoutInterval = 10
           request.allHTTPHeaderFields = ["accept": "application/json"]

           return URLSession.shared.dataTaskPublisher(for: request)
               .map(\.data)
               .decode(type: MovieResponse.self, decoder: JSONDecoder())
               .map(\.results)
               .receive(on: RunLoop.main)
               .catch { error in
                   Just([]).setFailureType(to: Error.self)
               }
               .eraseToAnyPublisher()
       }
   }
