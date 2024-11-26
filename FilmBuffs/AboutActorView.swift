//
//  AboutActorView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

// This will hold all the relevant details for an actor/actress
struct ActorDetails: Codable {
    let name: String
    let biography: String?
    let profilePath: String?
    let birthday: String?
    let placeOfBirth: String?
    
    enum CodingKeys: String, CodingKey {
        case name, biography, birthday, placeOfBirth = "place_of_birth", profilePath = "profile_path"
    }
}

struct AboutActorView: View {
    let actorId: Int
    // State variable becasue its contents will adjust the UI
    @State private var actorDetails: ActorDetails?

    var body: some View {
        VStack {
            // Put thier name at the top in large text
            if let details = actorDetails {
                Text(details.name)
                    .font(.largeTitle)
                    .padding()
                
                // Put their picture under it if available
                if let profilePath = details.profilePath {
                    // Asynchronously load up the image from the db
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")) { phase in
                        switch phase {
                        // Loading view if the network is taking time
                        case .empty:
                            ProgressView()
                        // If success display the image in the space allotted
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
                // Will display above the actor/actresses information about them
                Text("Biography")
                    .font(.headline)
                    .padding(.top)
                // Make it scrollable
                ScrollView {
                    Text(details.biography ?? "No Biogrpahy Available.")
                        .padding()
                }
                // Keep birthday non-scrollable at the bottom
                if let birthday = details.birthday, let placeOfBirth = details.placeOfBirth {
                    Text("Born: \(birthday) in \(placeOfBirth)")
                        .padding()
                }
            } else {
                ProgressView("Loading actor details...")
            }
        }
        // Once the page appears
        .onAppear {
            fetchActorDetails(actorId: actorId)
        }
    }

    /// Will use the network managers function to make a API call for information
    private func fetchActorDetails(actorId: Int) {
        NetworkManager.shared.fetchActorDetails(actorId: actorId) { result in
            // Main UI thread
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.actorDetails = details
                case .failure(let error):
                    print("Error fetching actor details: \(error.localizedDescription)")
                }
            }
        }
    }


}

#Preview {
    AboutActorView(actorId: 12345) // Example actor ID for preview
}

