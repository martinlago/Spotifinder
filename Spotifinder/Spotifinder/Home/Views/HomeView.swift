//
//  HomeView.swift
//  Spotifinder
//
//  Created by Martín Lago on 4/10/22.
//

import SwiftUI
import SpotifyWebAPI

struct HomeView: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var artistSearch: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? .clear : Color(.systemGray6))
                    .ignoresSafeArea()

                VStack {
                    TextField("Search artists", text: $artistSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .onSubmit {
                            homeViewModel.searchArtists(query: artistSearch)
                        }
                        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

                    if homeViewModel.artists.isEmpty {
                        placeholderView
                    } else {
                        List {
                            ForEach(homeViewModel.artists, id: \.self) { artist in
                                buildArtistItem(artist)
                                    .onTapGesture {
                                        homeViewModel.selectedArtist = artist
                                    }
                            }
                        }
                        .redacted(reason: homeViewModel.isFetchingArtists ? .placeholder : [])
                    }

                    Spacer()
                }
            }
            .navigationTitle("Spotifinder")
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private var placeholderView: some View {
        VStack {
            Spacer()
            Text("Search for your favorite artists!")
            Spacer()
        }
    }

    private func buildArtistItem(_ artist: Artist) -> some View {
        NavigationLink(destination: ArtistDetailView()) {
            ListItem(imageUrl: artist.images?.last?.url, text: artist.name)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
