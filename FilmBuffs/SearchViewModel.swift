//
//  SearchViewModel.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/24/24.
//

import Foundation

/// All the information needed about a media/person for the application
struct SuggestionItem: Identifiable {
    let id: Int                     // For the API search
    let text: String                // Actor/Actress name
    let mediaType: String           // Will be "movie", "person", or "tv"
    var description: String?        // May be updated
    var isLimitedInformation: Bool? // If they do not contain all fields
}

class SearchViewModel: ObservableObject {
    // Holds the list of search results (published because of UI updates)
    @Published var suggestions = [SuggestionItem]()
    // May or may not be an error message
    @Published var errorMessage: String?

    // This is an item defined as a DispatchWorkItem because it may run with a delay async
    private var debounceWorkItem: DispatchWorkItem?

    /// Handles search logic; fetches results of search from network
    func performSearch(query: String) {
        // Cancel the previous work item if it exists
        debounceWorkItem?.cancel()

        // Create a new work item for debouncing
        let workItem = DispatchWorkItem {
            // Calls function where query is what the user has typed thusfar
            // Result is the value within the closure (TMDB object array)
            NetworkManager.shared.searchMoviesAndActors(query: query) { result in
                // Ensures the upcoming code is executed on the main thread (UI changes need to occur on main)
                DispatchQueue.main.async {
                    // Checks the closure to see if it was success or failure
                    switch result {
                    case .success(let results):
                        // validResults holds only results that contain a title(tv) or name(actor/actress)
                        let validResults = results.filter { $0.title != nil || $0.name != nil }
                        
                        // Returning the validResults to suggestions as a list of SuggestionItems
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

                            // Return it -> will end up as one "suggestion" in "suggestions"
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
                                self.fetchBiography(for: suggestion)
                            } else if (suggestion.mediaType == "movie" || suggestion.mediaType == "tv") && suggestion.isLimitedInformation == true {
                                // Fetch details for movies or TV shows
                                self.fetchMediaDetails(for: suggestion)
                            }
                        }
                    case .failure(let error):
                        // Set suggestions = [] and set an error message
                        self.suggestions = []
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        // Assign and execute the work item after a delay (every 0.5 seconds)
        debounceWorkItem = workItem
        // Only do this update every 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }


    /// Helper function to fetch actor biography
    private func fetchBiography(for suggestion: SuggestionItem) {
        // Call the function to get the actor details (perform API call using thier id)
        NetworkManager.shared.fetchActorDetails(actorId: suggestion.id) { result in
            // Main thread execution (UI)
            DispatchQueue.main.async {
                // Finds the suggestion item in the suggestion array
                if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                    switch result {
                    // If the actor details were fetched successfully
                    case .success(let actorDetails):
                        // If a bio was pulled successfully and exists set it in the suggestion item
                        if let biography = actorDetails.biography, !biography.isEmpty {
                            self.suggestions[index].description = biography
                            self.suggestions[index].isLimitedInformation = false
                        // No bio exists
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
    
    /// Gets the details of movie and tv show
    private func fetchMediaDetails(for suggestion: SuggestionItem) {
        if suggestion.mediaType == "movie" {
            // Call the function to get the movie details (perform API call using thier id)
            NetworkManager.shared.fetchMovieDetails(movieId: suggestion.id) { result in
                // Main thread execution (UI)
                DispatchQueue.main.async {
                    // Find the suggestion item in the suggestions array
                    if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                        switch result {
                        // If the movie details were fetched successfully
                        case .success(let details):
                            // If the description was pulled successfully and exists
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
            // Call the function to get the tv show details (perform API call using thier id)
            NetworkManager.shared.fetchTvShowDetails(tvShowId: suggestion.id) { result in
                // Main thread execution (UI)
                DispatchQueue.main.async {
                    // Find the suggestion item in the suggestions array
                    if let index = self.suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                        switch result {
                        // If the tv show details were fetched successfully
                        case .success(let details):
                            // If the description was pulled successfully and exists
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
    
    /// Function that sets limited data flag if there is limited information
    private func suggestionHasLimitedData(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.isLimitedInformation ?? true
    }

    /// Helper function that returns the movie mediaType
    private func isMovie(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "movie"
    }
    /// Helper function that returns the actor/actress mediaType
    private func isPerson(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "person"
    }
    /// Helper function that returns the tv show mediaType
    private func isTvShow(_ suggestion: SuggestionItem) -> Bool {
        return suggestion.mediaType == "tv"
    }
}
