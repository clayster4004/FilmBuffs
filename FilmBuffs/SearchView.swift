//
//  SearchView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

struct SuggestionItem: Identifiable {
    let id: Int
    let text: String
    let mediaType: String  // Will be "movie", "person", or "tv"
    var description: String? // May be updated
    var isLimitedInformation: Bool?
}

struct SearchView: View {
    @State private var searchText = ""                 // Holds user input
    @State private var suggestions = [SuggestionItem]()        // Holds fetched movie/actor names
    @State private var errorMessage: String?           // Error message, if any
    @State private var debounceWorkItem: DispatchWorkItem?
    @EnvironmentObject var navi: MyNavigator           // Navigator for handling navigation

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search for movies or actors...", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchText) { oldValue, newValue in
                    performSearch(query: newValue)
                }
            
            // Display Suggestions
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(suggestions) { suggestion in
                    HStack {
                        Text(suggestion.text)
                        if suggestion.isLimitedInformation == true {
                            Text("*")
                                .foregroundColor(.red)
                        }
                    }
                    .onTapGesture {
                        guard !suggestion.text.isEmpty else {
                            print("Invalid Suggestion Detected")
                            return
                        }
                        
                        switch suggestion.mediaType {
                        case "movie":
                            navi.navigate(to: .AboutMovie(suggestion.id))
                        case "person":
                            navi.navigate(to: .AboutActor(suggestion.id))
                        case "tv":
                            navi.navigate(to: .AboutTvShow(suggestion.id))
                        default:
                            print("Unknown Media Type: \(suggestion.mediaType)")
                        }
                    }
                }
                Text("* May contain limited informaiton.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .navigationTitle("Search")
    }
    
    private func performSearch(query: String) {
        // Cancel the previous work item if it exists
        debounceWorkItem?.cancel()

        // Create a new work item for debouncing
        let workItem = DispatchWorkItem {
            NetworkManager.shared.searchMoviesAndActors(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        let validResults = results.filter { $0.title != nil || $0.name != nil }
                        self.suggestions = validResults.map {
                            var description: String?
                            var isLimited: Bool?

                            if $0.mediaType == "person" {
                                // Biography will be fetched separately
                                description = nil
                                isLimited = nil
                            } else if $0.mediaType == "movie" || $0.mediaType == "tv" {
                                // Use the overview if available
                                description = $0.overview
                                isLimited = ($0.overview == nil || $0.overview!.isEmpty)
                            }

                            return SuggestionItem(
                                id: $0.id,
                                text: $0.title ?? $0.name ?? "Unknown",
                                mediaType: $0.mediaType,
                                description: description,
                                isLimitedInformation: isLimited
                            )
                        }
                        self.errorMessage = nil

                        // Fetch additional details for items with limited information
                        for suggestion in self.suggestions {
                            if suggestion.mediaType == "person" {
                                // Fetch biographies for actors
                                fetchBiography(for: suggestion)
                            } else if (suggestion.mediaType == "movie" || suggestion.mediaType == "tv") && suggestion.isLimitedInformation == true {
                                // Fetch details for movies or TV shows
                                fetchMediaDetails(for: suggestion)
                            }
                        }
                    case .failure(let error):
                        self.suggestions = []
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        // Assign and execute the work item after a delay
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }

    // Helper function to fetch actor biography
    private func fetchBiography(for suggestion: SuggestionItem) {
        NetworkManager.shared.fetchActorDetails(actorId: suggestion.id) { result in
            DispatchQueue.main.async {
                if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                    switch result {
                    case .success(let actorDetails):
                        if let biography = actorDetails.biography, !biography.isEmpty {
                            self.suggestions[index].description = biography
                            self.suggestions[index].isLimitedInformation = false
                        } else {
                            self.suggestions[index].description = "Biography not available"
                            self.suggestions[index].isLimitedInformation = true
                        }
                    case .failure(let error):
                        print("Error fetching actor details: \(error.localizedDescription)")
                    }
                }
            }
        }
    }


    private func fetchMediaDetails(for suggestion: SuggestionItem) {
        if suggestion.mediaType == "movie" {
            NetworkManager.shared.fetchMovieDetails(movieId: suggestion.id) { result in
                DispatchQueue.main.async {
                    if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                        switch result {
                        case .success(let details):
                            if let overview = details.overview, !overview.isEmpty {
                                self.suggestions[index].description = overview
                                self.suggestions[index].isLimitedInformation = false
                            } else {
                                self.suggestions[index].description = "Overview not available"
                                self.suggestions[index].isLimitedInformation = true
                            }
                        case .failure(let error):
                            print("Error fetching movie details: \(error.localizedDescription)")
                        }
                    }
                }
            }
        } else if suggestion.mediaType == "tv" {
            NetworkManager.shared.fetchTvShowDetails(tvShowId: suggestion.id) { result in
                DispatchQueue.main.async {
                    if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                        switch result {
                        case .success(let details):
                            if let overview = details.overview, !overview.isEmpty {
                                self.suggestions[index].description = overview
                                self.suggestions[index].isLimitedInformation = false
                            } else {
                                self.suggestions[index].description = "Overview not available"
                                self.suggestions[index].isLimitedInformation = true
                            }
                        case .failure(let error):
                            print("Error fetching TV show details: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    
    private func suggestionHasLimitedData(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.isLimitedInformation ?? true
    }
        
    
    private func isMovie(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "movie"
    }
    private func isPerson(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "person"
    }
    private func isTvShow(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "tv"
    }
    
}

#Preview {
    SearchView()
}

