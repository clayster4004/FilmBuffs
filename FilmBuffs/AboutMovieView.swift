//
//  AboutMovieView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

//import SwiftUI
//
//struct AboutMovieView: View {
//    let movieId: Int
//    @EnvironmentObject var navi: MyNavigator
//    var body: some View {
//        VStack {
//            Text("About Movie View")
//            HStack {
//                Button("Go Back") {
//                    navi.navBack()
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct AboutMovieView: View {
    let movieId: Int  // Pass the movie ID
    @State private var movieDetails: MovieDetails?  // Model for movie details

    var body: some View {
        VStack {
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

struct MovieDetails: Codable {
    let title: String
    let overview: String?
}
