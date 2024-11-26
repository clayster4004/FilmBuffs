//
//  MainTabView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

/// Structure created to have tabs of my different views accessible as a banner on the bottom of the screen
struct MainTabView: View {
    // Accept the navigator as an environment object; can be used here
    @EnvironmentObject var navi: MyNavigator
    
    // Creates my current view (within the scene)
    var body: some View {
        // UI component to render the current navPath view of navi, now NavigationStack will
        // know to update depending on the state of navPath
        NavigationStack(path: $navi.navPath) {
            // Displays the Views at tabs at the bottom of the Screen
            TabView {
                // Main App Screen; Diplays whats new with the app
                WelcomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                // View to seach for anything
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                // View to take a photo
                CameraView(viewModel: CameraViewModel())
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")
                    }
                // Unused View to hold liked movies
                Text("Movies")
                    .tabItem {
                        Image(systemName: "film.fill")
                        Text("Movies")
                    }
                // Unused View to hold app settings
                Text("Settings")
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
            // Maps all the different navPath items to their respective View
            // Destination is the enum that defines navigation targets (in the case statements)
            // "for" tells the UI what type of data to look for in NavigationPath
            .navigationDestination(for: Destination.self) { d in
                // when navPath updates; NavigationStack reacts; find the enum match; UI renders
                switch d {
                case .AboutMovie(let id):
                    AboutMovieView(movieId: id)
                case .AboutActor(let id):
                    AboutActorView(actorId: id)
                case .AboutTvShow(let id):
                    AboutTvShowView(tvShowId: id)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
