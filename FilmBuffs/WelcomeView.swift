//
//  WelcomeView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI
/// Landing View of the application
struct WelcomeView: View {
    var body: some View {
        // Text welcoming the user and displaying the recent "news" on the application
        VStack {
            HStack {
                Text("Welcome to FilmBuffs!") // Big bold text and padding
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                Image(systemName: "popcorn") // Fun emoji
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding(.top)
            }
            // Display everything new in a vertical stack
            VStack(alignment: .leading) {
                Text("What's new?").font(.headline).padding(.bottom)
                Text("Click on the search tab to search for a movie or actor.")
                Text("Click on the movie or actor to see more information.")
                Text("Click on the camera pane to take a picture of a movie or actor.")
                Text("Click on the movie pane to look at previous inquiries.")
            }
            .padding()
            
            Spacer()
        }
        // Aligns content to the top of the screen and ensures it fills the entire screen
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

#Preview {
    WelcomeView()
}
