//
//  PkoMovieDBApp.swift
//  PkoMovieDB
//
//  Created by Maciej Szostak on 10/09/2024.
//

import SwiftUI

@main
struct PkoMovieDBApp: App {
    @StateObject var viewModel = MoviesViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
