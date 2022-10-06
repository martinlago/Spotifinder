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

    @Published var searchText: String = ""
    @Published var debouncedText: String = "" {
        didSet {
            searchArtists(query: debouncedText)
        }
    }
    @Published var artists: [Artist] = []
    @Published var isFetchingArtists: Bool = false
    @Published var selectedArtist: Artist?
    @Published var isFetchingAlbums: Bool = false
    @Published var artistAlbums: [Album] = []
    @Published var isFetchingTracks: Bool = false
    @Published var artistTopTracks: [Track] = []

    init() {
        $searchText
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.debouncedText = text
            }
            .store(in: &cancellables)
    }
    
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
                        if case .failure( _) = completion {
                            print("Error when retrieving artists")
                        }
                    },
                    receiveValue: { searchResults in
                        self.artists = searchResults.artists?.items.sorted(by: {
                            $0.popularity ?? 0 >= $1.popularity ?? 0
                        }) ?? []
                        print("Artists retrieved successfully")
                    }
                )
                .store(in: &cancellables)
        } else {
            artists = []
        }
    }

    func getArtistDetail() {
        getArtistTopAlbums()
        getArtistTopTracks()
    }

    func getArtistTopAlbums() {
        
        guard let uri = selectedArtist?.uri else {
            return
        }
        
        isFetchingAlbums = true
        
        spotifyUtils.api.artistAlbums(uri, groups: [.album], limit: 5)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    self.isFetchingAlbums = false
                    if case .failure( _) = completion {
                        print("Error when retrieving artist albums")
                    }
                },
                receiveValue: { result in
                    self.artistAlbums = result.items.sorted(by: {
                        $0.popularity ?? 0 >= $1.popularity ?? 0
                    })
                    print("Selected artist albums retrieved successfully")
                }
            )
            .store(in: &cancellables)
    }

    func getArtistTopTracks() {

        guard let uri = selectedArtist?.uri else {
            return
        }

        isFetchingTracks = true

        spotifyUtils.api.artistTopTracks(uri, country: "UY")
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    self.isFetchingTracks = false
                    if case .failure( _) = completion {
                        print("Error when retrieving artist tracks")
                    }
                },
                receiveValue: { result in
                    let sortedTracks = result.sorted(by: {
                        $0.popularity ?? 0 >= $1.popularity ?? 0
                    })
                    self.artistTopTracks = Array(sortedTracks.prefix(5))
                    print("Selected artist top tracks retrieved successfully")
                }
            )
            .store(in: &cancellables)
    }

    func clearSelectedArtistData() {
        selectedArtist = nil
        artistAlbums = []
        artistTopTracks = []
    }

}
