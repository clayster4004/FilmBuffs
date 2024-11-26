//
//  AboutTvShowView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/19/24.
//

// All the information needed for a tv show
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
    let tvShowId: Int // Pass the tv show id
    // Model for tv show details
    @State private var tvShowDetails: TvShowDetails?

    var body: some View {
        VStack {
            // Put the name if the tv show at the top
            if let details = tvShowDetails {
                Text(details.name)
                    .font(.largeTitle)
                    .padding()
                // Include the image associated with the tv show
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
                // Make a scrollable description
                ScrollView {
                    Text(details.overview ?? "No Overview Available")
                        .padding()
                }
                // Make a non-scrollable first air date at the bottom
                Text("First Air Date: \(details.firstAirDate)")
                    .padding()
            } else {
                ProgressView("Loading TV show details...")
            }
        }
        // Get the information about the tv show when the page is loaded up
        .onAppear {
            fetchTvShowDetails(tvShowId: tvShowId)
        }
    }

    private func fetchTvShowDetails(tvShowId: Int) {
        // Call network manager to make the API call for us
        NetworkManager.shared.fetchTvShowDetails(tvShowId: tvShowId) { result in
            // Main thred (UI)
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

