//
//  FilmBuffsApp.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

/// Main Entry Point for the Application
@main
struct FilmBuffsApp: App {
    // Define the navigator here so it is alive as long as the application is running; instantiated once
    @StateObject private var navi = MyNavigator()
    // Scene to hold all my different views
    var body: some Scene {
        // Standard single window iOS scene type
        WindowGroup {
            // This is where I want the app to start; all decendants will have the navigator
            MainTabView()
                .environmentObject(navi)
        }
    }
}
