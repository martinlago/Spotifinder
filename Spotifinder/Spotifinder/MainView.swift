//
//  ContentView.swift
//  Spotifinder
//
//  Created by Martín Lago on 29/9/22.
//

import SwiftUI
import Combine

struct MainView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @ObservedObject var user = User.shared
    
    var body: some View {
        ZStack {
            if user.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onOpenURL(perform: onLinkRetrieved(_:))
    }
    
    func onLinkRetrieved(_ url: URL) {
        homeViewModel.requestAccessAndRefreshTokens(url: url)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
