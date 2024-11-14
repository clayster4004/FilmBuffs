//
//  FilmBuffsApp.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//  Entry Point

import SwiftUI

@main
struct FilmBuffsApp: App {
    @StateObject private var navi = MyNavigator()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(navi)
        }
    }
}
