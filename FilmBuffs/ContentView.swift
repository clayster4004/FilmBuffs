//
//  ContentView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//  View

import SwiftUI

struct ContentView: View {
    @State private var searchResults: [String] = []  // Holds fetched movie/actor names
    @State private var errorMessage: String?         // Holds any error messages
    
    var body: some View {
        VStack {
            TextField("Search movies or actors", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button("Fetch Data") {
                fetchData()
            }
            .padding()
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                List(searchResults, id: \.self) { result in
                    Text(result)
                }
            }
        }
        .padding()
    }
    
    func fetchData() {
        NetworkManager.shared.searchMoviesAndActors(query: "Inception") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.searchResults = results.map { $0.title ?? $0.name ?? "Unknown" }
                    self.errorMessage = nil
                case .failure(let error):
                    self.searchResults = []
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
