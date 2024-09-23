//
//  ContentView.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 10/09/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MoviesViewModel

    var body: some View {
        MoviesListView(viewModel: viewModel)
    }
}
