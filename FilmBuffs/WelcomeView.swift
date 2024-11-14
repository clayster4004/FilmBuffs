//
//  WelcomeView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("How To: Film Buffs")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Spacer()
            
            Image(systemName: "popcorn")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            VStack(alignment: .leading) {
                Text("Click on the search pane to search for a movie or actor.")
                Text("Click on the movie or actor to see more information.")
                Text("Click on the camera pane to take a picture of a movie or actor.")
                Text("Click on the movie pane to look at previous inquiries.")
            }
            .padding()
            
            Spacer()
        }
        // Aligns content to the top
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

#Preview {
    WelcomeView()
}
