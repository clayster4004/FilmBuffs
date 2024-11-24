//
//  MainTabView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var navi: MyNavigator
    
    var body: some View {
        NavigationStack(path: $navi.navPath) {
            TabView {
                WelcomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                CameraView(viewModel: CameraViewModel())
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")
                    }
                Text("Movies")
                    .tabItem {
                        Image(systemName: "film.fill")
                        Text("Movies")
                    }
                Text("Settings")
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
//                ContentView()
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                        Text("Test API")
//                    }
            }
            .navigationDestination(for: Destination.self) { d in
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
