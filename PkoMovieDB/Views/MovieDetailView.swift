//
//  MovieDetailView.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 11/09/2024.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MoviesViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }

            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
                .font(.headline)

            Text(movie.overview)
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle(movie.title)
        .navigationBarItems(trailing: Button(action: {
                    viewModel.toggleFavorite(for: movie)
                }) {
                    Image(systemName: viewModel.isFavorite(movie: movie) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                })
    }
}
