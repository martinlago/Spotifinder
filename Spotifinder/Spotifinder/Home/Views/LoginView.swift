//
//  LoginView.swift
//  Spotifinder
//
//  Created by Martín Lago on 3/10/22.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        Button {
            homeViewModel.loginToSpotify()
        } label: {
            Text("Log in to Spotify")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
