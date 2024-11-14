//
//  MyNavigator.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

enum Destination {
    case AboutMovie
    case AboutActor
}

class MyNavigator: ObservableObject {
    @Published var navPath: NavigationPath = NavigationPath()
    
    func navigate(to d: Destination) {
        navPath.append(d)
    }
    
    func navBack() {
        navPath.removeLast()
    }
    
    func backToRoot() {
        while navPath.count > 0 {
            navPath.removeLast()
        }
    }
}
