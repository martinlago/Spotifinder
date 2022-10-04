//
//  HomeViewModel.swift
//  Spotifinder
//
//  Created by Martín Lago on 3/10/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    var spotifyUtils: SpotifyUtils = SpotifyUtils()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func loginToSpotify() {
        spotifyUtils.authorize()
    }
    
    func requestAccessAndRefreshTokens(url: URL) {
        
        spotifyUtils.api.authorizationManager.requestAccessAndRefreshTokens(
            redirectURIWithQuery: url,
            state: spotifyUtils.authorizationState
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error when retrieving tokens: \(error)")
            }
        })
        .store(in: &cancellables)
        
        // Prevent external attacks by replacing this string with each token request
        spotifyUtils.authorizationState = String.randomURLSafe(length: 128)
    }
}
