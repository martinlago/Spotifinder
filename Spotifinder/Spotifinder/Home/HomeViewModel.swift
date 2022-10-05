//
//  HomeViewModel.swift
//  Spotifinder
//
//  Created by Martín Lago on 3/10/22.
//

import Foundation
import Combine
import SpotifyWebAPI

class HomeViewModel: ObservableObject {
    
    var spotifyUtils: SpotifyUtils = SpotifyUtils()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var artists: [Artist] = []
    @Published var isFetchingArtists: Bool = false
    
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
    
    func searchArtists(query: String) {
        
        if !query.isEmpty {
            isFetchingArtists = true
            
            spotifyUtils.api.search(query: query, categories: [.artist])
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        self.isFetchingArtists = false
                        if case .failure( _) = completion {}
                    },
                    receiveValue: { searchResults in
                        self.artists = searchResults.artists?.items.sorted(by: {
                            $0.popularity ?? 0 >= $1.popularity ?? 0
                        }) ?? []
                        print("received \(self.artists.count) artists")
                    }
                )
                .store(in: &cancellables)
        } else {
            artists = []
        }
    }
}
