//
//  AboutActorView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

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
    @State private var actorDetails: ActorDetails?

    var body: some View {
        VStack {
            if let details = actorDetails {
                Text(details.name)
                    .font(.largeTitle)
                    .padding()
                
                if let profilePath = details.profilePath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")) { phase in
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
                
                Text("Biography")
                    .font(.headline)
                    .padding(.top)
                ScrollView {
                    Text(details.biography ?? "No Biogrpahy Available.")
                        .padding()
                }
                
                if let birthday = details.birthday, let placeOfBirth = details.placeOfBirth {
                    Text("Born: \(birthday) in \(placeOfBirth)")
                        .padding()
                }
            } else {
                ProgressView("Loading actor details...")
            }
        }
        .onAppear {
            fetchActorDetails(actorId: actorId)
        }
    }

    private func fetchActorDetails(actorId: Int) {
        NetworkManager.shared.fetchActorDetails(actorId: actorId) { result in
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

