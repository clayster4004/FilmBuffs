//
//  SearchView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var suggestions = [String]()
    @EnvironmentObject var navi: MyNavigator
    
    private let allSuggestions = [
        "The Matrix", "Inception", "Leonardo DiCaprio", "Scarlett Johansson",
        "Tom Cruise", "Avengers", "The Dark Knight", "Natalie Portman",
        "Johnny Depp", "Meryl Streep", "Brad Pitt", "Fight Club"
    ]
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search for movies or actors...", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchText) {
                    updateSuggestions(for: searchText)
                }
            
            List(suggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .onTapGesture {
                        if isMovie(suggestion) {
                            navi.navigate(to: .AboutMovie)
                            print("Tapped")
                        } else {
                            navi.navigate(to: .AboutActor)
                        }
                    }
            }
            
            Spacer()  // Placeholder for the autofill suggestions and results
        }
        .navigationTitle("Search")
    }
    
    // Function to update suggestions based on search text
    private func updateSuggestions(for query: String) {
        if query.isEmpty {
            suggestions = []
        } else {
            suggestions = allSuggestions.filter { $0.localizedCaseInsensitiveContains(query) }
        }
    }

    private func isMovie(_ suggestion: String) -> Bool {
        //return suggestion.contains("The") || suggestion.contains("Club") || suggestion.contains("Inception")
        return true
    }
}

#Preview {
    SearchView()
}
