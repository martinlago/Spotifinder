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
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: artist.images?.last?.url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                // TODO: Add placeholder image
                Text("X")
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 32))

            Text(artist.name)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
