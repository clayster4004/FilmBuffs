//
//  AboutActorView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/14/24.
//

import SwiftUI

struct AboutActorView: View {
    @EnvironmentObject var navi: MyNavigator
    var body: some View {
        VStack {
            Text("About Actor View")
            HStack {
                Button("Go Back") {
                    navi.navBack()
                }
            }
        }
    }
}
