//
//  MainTabView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WelcomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("Search")
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
        }
    }
}

#Preview {
    MainTabView()
}
