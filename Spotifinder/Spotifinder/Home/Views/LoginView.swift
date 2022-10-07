//
//  LoginView.swift
//  Spotifinder
//
//  Created by Martín Lago on 3/10/22.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? .clear : Color(.systemGray6))
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Log in to search for your favorite artists")
                        .font(.system(size: 20, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        homeViewModel.loginToSpotify()
                    } label: {
                        buildLoginButton()
                    }
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Spotifinder")
        }
    }
    
    private func buildLoginButton() -> some View {
        VStack {
            if homeViewModel.isRetrievingTokens {
                ProgressView()
            } else {
                Text("Log in to Spotify")
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding(.vertical, 12)
        .frame(width: 220)
        .background(RoundedRectangle(cornerRadius: 32).foregroundColor(.green))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
