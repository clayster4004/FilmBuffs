//
//  AboutMovieView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

struct AboutMovieView: View {
    @EnvironmentObject var navi: MyNavigator
    var body: some View {
        VStack {
            Text("About Movie View")
            HStack {
                Button("Go Back") {
                    navi.navBack()
                }
            }
        }
    }
}
