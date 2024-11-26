//
//  SearchView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

/// This view is for searching for movies, actor/actresses, and TV shows
struct SearchView: View {
    // Saved as a state variable because its contents will adjust the UI
    @State private var searchText = ""
    // Observes the ViewModel which contains logic
    @ObservedObject var viewModel = SearchViewModel()
    // Accept the navigator as an environment object; can be used here
    @EnvironmentObject var navi: MyNavigator

    var body: some View {
        VStack {
            // TextField's can be typed into, text field binds the typed in text to "seachText" var
            TextField("Search for movies or actors...", text: $searchText)
                .padding()
                .background(Color(.systemGray6)) // Make the box gray
                .cornerRadius(8)                 // Box Rounded
                .padding(.horizontal)            // Padding on the sides
                // When ever this text box changes the "performSearch" will run
                .onChange(of: searchText) { oldValue, newValue in
                    viewModel.performSearch(query: newValue)
                }

            // If their is an error that occurs display it for the user
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            // Code will get here if there is no error
            } else {
                // Suggestions will be generated based on what the user typed
                List(viewModel.suggestions) { suggestion in
                    HStack {
                        Text(suggestion.text)
                        // If the database does not contain all the information; a star is placed
                        if suggestion.isLimitedInformation == true {
                            Text("*")
                                .foregroundColor(.red)
                        }
                    }
                    // When the user clicks a suggestion; navigate to that view
                    .onTapGesture {
                        switch suggestion.mediaType {
                        case "movie": navi.navigate(to: .AboutMovie(suggestion.id))
                        case "person": navi.navigate(to: .AboutActor(suggestion.id))
                        case "tv": navi.navigate(to: .AboutTvShow(suggestion.id))
                        default: break
                        }
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}

