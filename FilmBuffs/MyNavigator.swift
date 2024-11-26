//
//  MyNavigator.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

/// Enum to provide the possible navigation destinations
enum Destination: Hashable {
    // Each takes an Int argument (id for database lookup)
    case AboutMovie(Int)
    case AboutActor(Int)
    case AboutTvShow(Int)
}

/// Defines the observable Navigator
class MyNavigator: ObservableObject {
    // Create a published variable to keep track of the navPath (will trigger UI changes)
    @Published var navPath: NavigationPath = NavigationPath() // NavigationPath is a data structure
    
    /// Adding to the navPath (trigger UI change)
    func navigate(to d: Destination) {
        navPath.append(d)
    }
    
    /// Removing the last item from navPath (trigger UI to most recent screen)
    func navBack() {
        navPath.removeLast()
    }
    
    /// Remove all from navPath (trigger UI change to original view)
    func backToRoot() {
        while navPath.count > 0 {
            navPath.removeLast()
        }
    }
}
