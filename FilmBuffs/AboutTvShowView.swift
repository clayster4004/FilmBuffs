//
//  AboutTvShowView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/19/24.
//

struct TvShowDetails: Codable {
    let name: String
    let overview: String?
    let firstAirDate: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name, overview, firstAirDate = "first_air_date", posterPath = "poster_path"
    }
}

import SwiftUI

struct AboutTvShowView: View {
    let tvShowId: Int
    @State private var tvShowDetails: TvShowDetails?

    var body: some View {
        VStack {
            if let details = tvShowDetails {
                Text(details.name)
                    .font(.largeTitle)
                    .padding()

                if let posterPath = details.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                        case .failure:
                            Text("Image not available")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                Text("Overview")
                    .font(.headline)
                    .padding(.top)
                ScrollView {
                    Text(details.overview ?? "No Overview Available")
                        .padding()
                }

                Text("First Air Date: \(details.firstAirDate)")
                    .padding()
            } else {
                ProgressView("Loading TV show details...")
            }
        }
        .onAppear {
            fetchTvShowDetails(tvShowId: tvShowId)
        }
    }

    private func fetchTvShowDetails(tvShowId: Int) {
        NetworkManager.shared.fetchTvShowDetails(tvShowId: tvShowId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.tvShowDetails = details
                case .failure(let error):
                    print("Error fetching TV show details: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    AboutTvShowView(tvShowId: 12345) // Example TV show ID for preview
}

