//
//  AboutMovieView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

// Has the needed information for movies
struct MovieDetails: Codable {
    let title: String
    let overview: String?
}

struct AboutMovieView: View {
    let movieId: Int  // Pass the movie ID
    // Model for movie details
    @State private var movieDetails: MovieDetails?

    var body: some View {
        VStack {
            // Title at the top
            if let details = movieDetails {
                Text(details.title)
                    .font(.largeTitle)
                    .padding()
                Text(details.overview ?? "No Overview Available")
                    .padding()
            } else {
                ProgressView("Loading movie details...")
            }
        }
        // Get the movie details when the page appears
        .onAppear {
            fetchMovieDetails(movieId: movieId)
        }
    }

    private func fetchMovieDetails(movieId: Int) {
        // Call API to fetch movie details by ID
        NetworkManager.shared.fetchMovieDetails(movieId: movieId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.movieDetails = details
                case .failure(let error):
                    print("Error fetching movie details: \(error)")
                }
            }
        }
    }
}

