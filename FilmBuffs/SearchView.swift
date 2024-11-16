//
//  SearchView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

//import SwiftUI
//
//struct SearchView: View {
//    @State private var searchText: String = ""
//    @State private var suggestions = [String]()
//    @State private var errorMessage: String?
//    @EnvironmentObject var navi: MyNavigator
//    
////    private let allSuggestions = [
////        "The Matrix", "Inception", "Leonardo DiCaprio", "Scarlett Johansson",
////        "Tom Cruise", "Avengers", "The Dark Knight", "Natalie Portman",
////        "Johnny Depp", "Meryl Streep", "Brad Pitt", "Fight Club"
////    ]
//    
//    var body: some View {
//        VStack {
//            // Search Bar
//            TextField("Search for movies or actors...", text: $searchText)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .padding(.horizontal)
//                .onChange(of: searchText) {
//                    performSearch(for: searchText)
//                }
//            
//            List(suggestions, id: \.self) { suggestion in
//                Text(suggestion)
//                    .onTapGesture {
//                        if isMovie(suggestion) {
//                            navi.navigate(to: .AboutMovie)
//                            print("Tapped")
//                        } else {
//                            navi.navigate(to: .AboutActor)
//                        }
//                    }
//            }
//            
//            Spacer()  // Placeholder for the autofill suggestions and results
//        }
//        .navigationTitle("Search")
//    }
//    
//    // Function to update suggestions based on search text
//    private func updateSuggestions(for query: String) {
//        if query.isEmpty {
//            suggestions = []
//        } else {
//            suggestions = allSuggestions.filter { $0.localizedCaseInsensitiveContains(query) }
//        }
//    }
//
//    private func isMovie(_ suggestion: String) -> Bool {
//        //return suggestion.contains("The") || suggestion.contains("Club") || suggestion.contains("Inception")
//        return true
//    }
//}
//
//#Preview {
//    SearchView()
//}

import SwiftUI

struct SuggestionItem: Identifiable {
    let id = UUID()
    let text: String
    let mediaType: String  // Movie or person
}

struct SearchView: View {
    @State private var searchText = ""                 // Holds user input
    @State private var suggestions = [SuggestionItem]()        // Holds fetched movie/actor names
    @State private var errorMessage: String?           // Error message, if any
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
                    Text(suggestion.text)
                        .onTapGesture {
                            if isMovie(suggestion) {
                                navi.navigate(to: .AboutMovie)
                            } else {
                                navi.navigate(to: .AboutActor)
                            }
                        }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Search")
    }
    
    // Function to perform the search
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            suggestions = []  // Clear suggestions when search is empty
            return
        }
        NetworkManager.shared.searchMoviesAndActors(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        self.suggestions = results.map {
                            SuggestionItem(text: $0.title ?? $0.name ?? "", mediaType: $0.mediaType)
                        }
                        self.errorMessage = nil
                    case .failure(let error):
                        self.suggestions = []
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        
//        NetworkManager.shared.searchMoviesAndActors(query: query, completion: { result in
//            DispatchQueue.main.async(execute: {
//                switch result {
//                case .success(let results):
//                    self.suggestions = results.map {
//                        SuggestionItem(text: $0.title ?? $0.name ?? "", mediaType: $0.mediaType)
//                    }
//                    self.errorMessage = nil
//                case .failure(let error):
//                    self.suggestions = []
//                    self.errorMessage = error.localizedDescription
//                }
//            })
//        })
        
//        NetworkManager.shared.searchMoviesAndActors(query: query, completion) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let results):
//                    self.suggestions = results.map {
//                        SuggestionItem(text: $0.title ?? $0.name ?? "", mediaType: $0.mediaType)
//                    }
//                    self.errorMessage = nil
//                case .failure(let error):
//                    self.suggestions = []
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
        
        
    }
    
    private func isMovie(_ suggestion: SuggestionItem) -> Bool {
        // Temporary logic to determine if suggestion is a movie or actor
        // Ideally, we’d refine this once we have more detailed data
//        return suggestion.contains("The") || suggestion.contains("Club") || suggestion == "Inception"
        return suggestion.mediaType == "movie"
    }
}

#Preview {
    SearchView()
}

